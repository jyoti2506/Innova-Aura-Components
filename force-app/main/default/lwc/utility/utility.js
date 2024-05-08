const getRecordIdFromURL = () => {
    const params = new URLSearchParams(window.location.search);
    return params.get('recId');
};

export { getRecordIdFromURL };
