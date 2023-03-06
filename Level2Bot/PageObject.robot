*** Variables  ***
${URL}    https://robotsparebinindustries.com/#/robot-order
${RightsOkButton}    //button[@class='btn btn-dark']
${HeadList}    //select[@id='head']
${LegsTextField}    //input[@class='form-control' and @placeholder='Enter the part number for the legs']
${AddressTextField}    //input[@id='address']
${PreviewButton}    //button[@id='preview']
${ImageBody}    //div[@id='robot-preview-image']
${OrderButton}  //button[@id='order']
${Receipt}    //div[@id='receipt']
${ErrorAlert}    //div[@class='alert alert-danger']
${OrderAnotherButton}    //button[@id='order-another']