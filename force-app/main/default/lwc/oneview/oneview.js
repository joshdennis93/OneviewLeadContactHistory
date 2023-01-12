import { LightningElement, api } from "lwc";
import getRecords from "@salesforce/apex/OneViewController.getRecords";

export default class FieldHistoryTable extends LightningElement { 
    @api recordId;
    @api cardTitle;
    @api cardIcon;

    fieldHistory;
    error;

    columns = [
        { label: 'Date', fieldName: 'createdDate', type: 'date', typeAttributes:
            {
                month: "2-digit",
                day: "2-digit",
                year: "2-digit",
                hour:"2-digit",
                minute: "2-digit"
            }
        },
        { label: 'Field', fieldName: 'field' },
        { label: 'User', fieldName: 'createdBy' },
        { label: 'Original Value', fieldName: 'oldValue' },
        { label: 'New Value', fieldName: 'newValue' },
        { label: 'Object', fieldName: 'objectName', cellAttributes: {iconName: {fieldName: 'objectIcon'}}}
    ];

    connectedCallback() {
        this.loadFieldHistory();
    }

    loadFieldHistory() {
        getRecords({ recordId: this.recordId })
            .then(result => {
                this.fieldHistory = result.map(element => {
                    let newElement = {...element};
                    // this assumes SF has a native SLDS icon for the object, if you try and extend the component to e.g. custom objects, you may need a different approach here.
                    newElement.objectIcon = 'standard:' + newElement.objectName.toLowerCase();
                    return newElement;
                });
                console.log(this.fieldHistory);
            })
            .catch(error => {
                this.error = error;
            });
    }

}
