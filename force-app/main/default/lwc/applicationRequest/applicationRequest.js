import { LightningElement, track,wire,api} from 'lwc';
import getApplication from '@salesforce/apex/ApplicationRequest.getApplication';
import pickListValueDynamically from '@salesforce/apex/ApplicationRequest.pickListValueDynamically';

export default class ApplicationRequest extends LightningElement {

//     @track value;
//     @track BrandPicklistValues=[];

//    @wire(getObjectInfo, { objectApiName: User_OBJECT })
//     objectInfo; 
    
    @track regionValue = '';
    @track brandValue = '';

     @track regionOptions = [];
     @track brandOptions = [];
      
    @api selectedRegion;
    @api selectedBrand;
    @api selectedBrand1;

    @api OutList = [];
    @api OutString = '';
    @api OutStringSub = '';
    @api OutStringSoftware = '';//not in use

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
    EMEABrandValues= [];
    NonEMEABrandValues= [];


    // showEMEA=false;
    // showNonEMEA=false;

    connectedCallback() {
        console.log('connectedCallback : brand :: ' + this.selectedBrand);
        console.log('connectedCallback : region :: ' + this.selectedRegion);
        console.log('connectedCallback : brand :: ' + this.selectedBrand1);
        this.regionValue = this.selectedRegion;
        this.brandValue = this.selectedBrand? this.selectedBrand:this.selectedBrand1

       
         
        console.log('inside connectedcallback')
        console.log(this.EMEABrandValues);
        console.log(this.NonEMEABrandValues);
        if (this.regionValue === 'EMEA (Europe)') {
                    //  this.showEMEA=true;
                    //  this.showNonEMEA=false;
                    this.brandOptions = this.EMEABrandValues;
                    console.log(this.brandOptions);
                                                    }
                                                    // else{
                                                    //     this.showNonEMEA=true;
                                                    //     this.showEMEA=false;
                                                    // }
       
       
    }

    @wire(pickListValueDynamically, {customObjInfo: {'sobjectType' : 'User'},selectPicklistApi: 'Innova_Brand__c'}) 
    
     selectBrandValues({ data, error }) {
            if (data) {






                

                // this.brandOptions = data
                // .filter(option => !(this.regionValue === 'EMEA(Europe)' && option.custFldvalue === 'Volt'))
                // .map(option => ({
                //   label: option.custFldlabel,
                //   value: option.custFldvalue
                // }));
            


                    console.log(data)
                    this.brandOptions = data.map(option => ({
                        label: option.custFldlabel,
                        value: option.custFldvalue
                    }));



                    this.NonEMEABrandValues=this.brandOptions;
                    this.EMEABrandValues = this.brandOptions.filter(option => option.value !==  'Volt');
                     
                    console.log('inside selectBrandValues')
                    console.log(this.EMEABrandValues);
                    console.log(this.NonEMEABrandValues);
            
                    if (this.regionValue === 'EMEA (Europe)') {
                                // this.showEMEA=true;
                                // this.showNonEMEA=false;
                                this.brandOptions = this.EMEABrandValues;
            
                                
                                console.log(this.brandOptions);
                            }
                            // else{

                            //     this.showEMEA=false;
                            //     this.showNonEMEA=true;
                            // }






                // if (this.regionValue === 'EMEA(Europe)') {
                //     this.brandOptions = this.brandOptions.filter(option => option.value !== 'Volt');
                // }



            } else if (error) {
                console.error(error);
            }
        }

         @wire(pickListValueDynamically, {customObjInfo: {'sobjectType' : 'User'},selectPicklistApi: 'Innova_Region__c'}) 
    selectRegionValues({ data, error }) {
        if (data) {
            console.log(data)
            this.regionOptions = data.map(option => ({
                label: option.custFldlabel,
                value: option.custFldvalue
            }));
        } else if (error) {
            console.error(error);
        }
    }





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


    // get fetchoptions(){

    //     if(this.regionValue === 'EMEA (Europe)'){
    //         brandOptions = this.brandOptions.filter(option => option.value !== 'Volt');
    //         }
    //         else{
    //         brandOptions = [...this.brandOptions]
    //         }
    //         return brandOptions

    // }

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
        var Flow4='{input01},'

        var op = ''
        var op1=''
        var eachsoftware = ''//not in use

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
            op = op + Flow.replace('{input1}', row.Name).replace('{input3}', radio);
            op1 = op1+Flow4.replace('{input01}', row.Name)
           
            
            if(row.Innova_Access_Level__c!= undefined &&( row.Name== 'MyInnova Portal (Sharepoint)'|| row.Name== 'Sharepoint' )){
            op=op+Flow2.replace('{input6}',row.Innova_Access_Level__c)
            }

            if(row.Innova_Description_of_the_Request__c!= null && row.Innova_Description_of_the_Request__c!= ''){
                op=op+Flow3.replace('{input7}',row.Innova_Description_of_the_Request__c)
                }

                

            eachsoftware = Flow.replace('{input1}', row.Name).replace('{input2}', row.Innova_Description_of_the_Request__c).replace('{input3}', radio)//not in use
        })
        this.OutList = this.selectedItems;
        this.OutString = op;
        this.OutStringSub = op1;

        this.OutStringSoftware = eachsoftware;

    }



   
    handleBrandChange(event) {
        this.showtable = false;
        setTimeout(() => {
            this.brandValue = event.detail.value;
          

        }, 1500);
        
    }
    handleRegionChange(event) {
        this.showtable = false;

        console.log('inside regionchange')
        console.log(this.EMEABrandValues);
        console.log(this.NonEMEABrandValues);
        console.log(this.regionValue)

        if (event.detail.value === 'EMEA (Europe)') {
            // this.showEMEA=true;
            // this.showNonEMEA=false;
            this.brandOptions = this.EMEABrandValues;
            
            console.log(this.brandOptions);
        }
        else{
            // this.showEMEA=false;
            // this.showNonEMEA=true;
            this.brandOptions=this.NonEMEABrandValues;

        }
        setTimeout(() => {
            this.regionValue = event.detail.value;
        }, 2000);

        

        // this.brandValue = ''; 
       
    }



    //Method 2
    @wire(getApplication, {
        searchKey: '$searchKey',
        pageNumber: '$currentPage',
        region: '$regionValue',
        brand: '$brandValue'

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
                if(this.listContains(this.selectedItems,item.Id)!=-1 && (item.Name== 'MyInnova Portal (Sharepoint)'|| item.Name== 'Sharepoint' ))
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
        var canSubmitCase = false;
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
        this.OutStringSub='';
        this.OutString='';
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