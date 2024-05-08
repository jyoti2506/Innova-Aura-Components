import { LightningElement, track,wire,api} from 'lwc';
import getApplication from '@salesforce/apex/newHireRequest.getApplication';


export default class newHireRequest extends LightningElement {
    @api OutList = [];
    @api OutString = '';
    @api OutStringSoftware = '';

    @track searchKey = '';
    @track value = '';
    showtable = false;
    @track columns = [
        {  label: 'Name',   fieldName: 'Name'  },
        {   label: 'Id',  fieldName: 'Id'  }
    ];

    @track applicationList = [];

    @track currentPage = 1;
    @track pageSize = 15; //Number of records to display per page
    @track totalRecords = 0;
    @track totalPages = 0;
    selectedItems = [];

    get accessOptions() {
        return [
            {  value: 'Contribute',  label: 'Contribute' },
            {  value: 'Full Control',  label: 'Full Control'  },
            {  value: 'Read',  label: 'Read'  }
        ];
    }
  

    get options() {
        return [
            { label: 'Add',  value: 'Add' },
            { label: 'Edit',  value: 'Edit' },
            { label: 'Delete', value: 'Delete' }
        ];
    }
    
    get isfirst() {
        return this.currentPage === 1
    }
    get islast() {
        return this.currentPage === this.totalPages
    }

    handlePageNavigation(event) {
        const direction = event.target.dataset.page;
        console.log(this.currentPage)
        console.log(this.totalPages)


        if (direction === 'prev' && this.currentPage > 1) {
            //this.currentPage -= 1;
            this.showtable = false;
            setTimeout(() => {
                this.currentPage -= 1;
                //this.prepopulated();

            }, 1000);
        } else if (direction === 'next' && this.currentPage < this.totalPages) {
           // this.currentPage += 1;
            this.showtable = false;
            setTimeout(() => {
               // this.prepopulated();
               this.currentPage += 1;

            }, 1000);
        }
    }


    sendvalue() {
        var Flow = '<strong> Application Name </strong> - {input1}<br/><strong> Action </strong>- {input3}<br/>'
       // var Flow1='<strong> Requires IT Approval </strong> - {input1}<br/>'
        var Flow2='<strong> Access Level </strong> - {input6}<br/>'
        var Flow3='<strong> Description of the Request </strong> - {input7}<br/><br/>'

        var op = ''
        var eachsoftware = ''

        this.selectedItems.forEach(row => {
            var radio;
            if (row.Innova_Add__c) {
                radio = 'Add';
            }
            if (row.Innova_Edit__c) {
                radio = 'Edit';
            }
            if (row.Innova_Delete__c) {
                radio = 'Delete';
            }
            op = op + Flow.replace('{input1}', row.Name).replace('{input2}', row.Innova_Description_of_the_Request__c).replace('{input3}', radio).replace('{input4}', row.Innova_Requires_IT_Approval__c).replace('{input5}', row.Innova_Access_Level__c);
           
            // if(row.Innova_Requires_IT_Approval__c){
            //     op=op+Flow1.replace('{input1}',row.Innova_Requires_IT_Approval__c)
            // }
            if(row.Innova_Access_Level__c!= undefined && row.Name== 'MyInnova Portal (Sharepoint)'){
            op=op+Flow2.replace('{input6}',row.Innova_Access_Level__c)
            }

            if(row.Innova_Description_of_the_Request__c!= null){
                op=op+Flow3.replace('{input7}',row.Innova_Description_of_the_Request__c)
                }



            eachsoftware = Flow.replace('{input1}', row.Name).replace('{input2}', row.Innova_Description_of_the_Request__c).replace('{input3}', radio)
        })
        this.OutList = this.selectedItems;
        this.OutString = op;
        this.OutStringSoftware = eachsoftware;

    }

    //Method 2
    @wire(getApplication, {
        searchKey: '$searchKey',
        pageNumber: '$currentPage'
    })
    wiredAccounts({
        data,
        error
    }) {

        if (data) {
            this.totalRecords = data.length + ((this.currentPage - 1) * 15);
            console.log('getApplication : applicationList :: ' +  JSON.stringify(this.applicationList));
            this.applicationList = data.slice(0, 15);
            this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
            this.applicationList = this.applicationList.map(item =>{
                var display=false;
                if(this.listContains(this.selectedItems,item.Id)!=-1)
                display=true;
             return ({...item,displayAccessLevel: display})});
            
            this.showtable = true;
            
            setTimeout(() => {
                this.prepopulated();

            }, 1000);

        } else if (error) {
            console.log(error);
        }
    }
    searchApplication(event) {
        this.currentPage = 1;
        this.showtable = false;
        this.searchKey = event.target.value;
    }




    handleSaveRecord(evt) {
        console.log('inside handleSave')
        var id = evt.target.dataset.id;
        this.applicationList.forEach(row => {
            if(row.Id == id && (row.Name== 'MyInnova Portal (Sharepoint)'|| row.Name== 'Sharepoint' )){
                row.displayAccessLevel = true;
            }
            var inputElement = this.template.querySelector(`lightning-textarea[data-id="${row.Id}"]`);
            var radioElement = this.template.querySelector(`lightning-radio-group[data-id="${row.Id}"]`);
            var comboboxElement = this.template.querySelector(`lightning-combobox[data-id="${row.Id}"]`);


            var comboboxValue = '';
            if (comboboxElement) {
                comboboxValue = comboboxElement.value;
                console.log('combobox Value:', comboboxValue);

            }

            if (inputElement && radioElement) {
                var inputValue = inputElement.value;
                var radioValue = radioElement.value;

                console.log('Input Value:', inputValue);
                console.log('Radio Value:', radioValue);




                if (radioValue === 'Add' || radioValue === 'Edit' || radioValue === 'Delete') {
                    // var key=row.Id+'';
                    // stringMap.set(key,op);
                    var isadd = radioValue === 'Add' ? true : false
                    var isedit = radioValue === 'Edit' ? true : false
                    var isdelete = radioValue === 'Delete' ? true : false

                    var index = this.listContains(this.selectedItems, row.Id)
                    if (index != -1) {
                        this.selectedItems.splice(index, 1)
                    }

                    this.selectedItems.push({
                        Id: row.Id,
                        Name: row.Name,
                        Innova_Add__c: isadd,
                        Innova_Edit__c: isedit,
                        Innova_Delete__c: isdelete,
                        Innova_Description_of_the_Request__c: inputValue,
                        Innova_Requires_IT_Approval__c: row.Innova_Requires_IT_Approval__c,
                        Innova_Access_Level__c: comboboxValue
                    });


                }
            }
        });

        console.log('sendvalue')
        this.sendvalue()

        console.log('Selected Items:', this.selectedItems);
        console.log(this.applicationList.length)
        this.applicationList.forEach(element => {
            console.log('Selected Items')
        });

    }

    handleResetClick(event) {
        this.value = undefined;
        console.log(event.target.dataset.Id)
        console.log(JSON.stringify(event.target.dataset))
        var id = event.target.dataset.id;
        var inputElement = this.template.querySelector(`lightning-textarea[data-id="${id}"]`);
        var radioElement = this.template.querySelector(`lightning-radio-group[data-id="${id}"]`);
        inputElement.value = undefined;
        radioElement.value = undefined;

        var index = this.listContains(this.selectedItems, id)

        if (index != -1) {
            this.selectedItems.splice(index, 1)
        }
        this.handleSaveRecord(event);
        this.applicationList.forEach(row => {
            if(row.Id == id){
                row.displayAccessLevel = false;
            }
        });
    }


    listContains(dataList, Id) {

        for (var i = 0; i < dataList.length; i++) {
            if (dataList[i].Id == Id) {

                return i;
            }
        }

        return -1;
    }


    prepopulated() {
        this.selectedItems.forEach(row => {
            var index = this.listContains(this.applicationList, row.Id)
            if (index != -1) {
                console.log('prepopulating', row.Name);
               // row.displayAccessLevel = true; 
                var inputElement = this.template.querySelector(`lightning-textarea[data-id="${row.Id}"]`);
                var radioElement = this.template.querySelector(`lightning-radio-group[data-id="${row.Id}"]`);
                var comboboxElement = this.template.querySelector(`lightning-combobox[data-id="${row.Id}"]`);
                
                console.log(inputElement)
                console.log(radioElement)
                console.log(comboboxElement)
                if (inputElement != null) {
                    inputElement.value = row.Innova_Description_of_the_Request__c;
                    console.log(inputElement.value)
                }

                if (radioElement != null) {


                    var radio;
                    if (row.Innova_Add__c) {
                        radio = 'Add';
                    }
                    if (row.Innova_Edit__c) {
                        radio = 'Edit';
                    }
                    if (row.Innova_Delete__c) {
                        radio = 'Delete';
                    }

                    radioElement.value = radio;

                    console.log(radioElement.value)
                }

                if (comboboxElement != null) {
                    comboboxElement.value = row.Innova_Access_Level__c;
                    console.log(comboboxElement.value)
					
                }
				 


            }
        })
    }

}