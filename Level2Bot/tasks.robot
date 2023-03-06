*** Settings ***
Documentation     Orders robots from RobotSpareBin Industries Inc.
...               Saves the order HTML receipt as a PDF file.
...               Saves the screenshot of the ordered robot.
...               Embeds the screenshot of the robot to the PDF receipt.
...               Creates ZIP archive of the receipts and the images.

Resource   PageObject.robot
Library    RPA.Browser.Selenium
Library    RPA.HTTP
Library    RPA.PDF    
Library    RPA.Tables
Library    Collections
Library    RPA.Database
Library    RPA.Desktop
Library    RPA.Robocorp.Process
Library    RPA.Archive
Library    OperatingSystem

*** Variables ***


*** Tasks ***
Order robots from RobotSpareBin Industries Inc
    Download Orders File
    ${MyOrdersTable}=    Load Orders data as table
    Navigate to Website
    Perform Order Selections    ${MyOrdersTable}
    Archive PDF Files
    Teardown

*** Keywords ***
Download Orders File
    Download    https://robotsparebinindustries.com/orders.csv  target_file=./input/orders.csv

Load Orders data as table
    ${OrdersTable}    Read table from CSV    ./input/orders.csv
    RETURN    ${OrdersTable}  

Navigate to Website
    Open Chrome Browser    ${URL}    maximized=True
    Click Button When Visible    ${RightsOkButton}

Perform Order Selections
    [Arguments]    ${table}
    FOR    ${OrderRow}    IN    @{table}
        #Head:
        Select From List By Value    ${HeadList}    ${OrderRow}[\Head]
        
        #Body:
        Click Element    //input[@value=${OrderRow}[\Body]]

        #Legs:
        Input Text    ${LegsTextField}    ${OrderRow}[\Legs]

        #Address
        Input Text    ${AddressTextField}     ${OrderRow}[\Address]

        #Preview Order
        Click Button    ${PreviewButton}
        Scroll Element Into View    ${ImageBody}

        #Capture Image to File
        ${OrderNumber}=    Set Variable  ${OrderRow}[Order number]
        Create Directory    ./images
        Screenshot    ${ImageBody}    filename=./images/${OrderNumber}.png

        #Submit Order
        Click Button    ${OrderButton}
        
        FOR    ${1}    IN RANGE    1    5
             Sleep    1 second
             ${ErrorBoolean}=    Is Element Visible   ${ErrorAlert}

            IF    ${ErrorBoolean}
                Click Button    ${OrderButton}
            END
        END
               
        
        #Store receipt text in PDF
        ${ReceiptContent}    Get Element Attribute    ${Receipt}    outerHTML
        Html To Pdf    ${ReceiptContent}    ./pdf_files/Order-${OrderNumber}.pdf
        ${FileList}    Create List    ./images/${OrderNumber}.png
        Add Files To Pdf     ${FileList}    ./pdf_files/Order-${OrderNumber}.pdf    append=True

        #Order Another
        Click Button    ${OrderAnotherButton}
        Click Button When Visible    ${RightsOkButton}

    END

Archive PDF Files
   Create Directory    ./pdf_files
   Archive Folder With Zip   ./pdf_files    orders.zip
   Move File    ./orders.zip    ${OUTPUT_DIR}

Teardown
    Close All Browsers

Minimal task
    Log    Done.

