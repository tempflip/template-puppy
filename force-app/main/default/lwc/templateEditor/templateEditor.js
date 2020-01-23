import { LightningElement, wire } from 'lwc';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';

import quillZip from '@salesforce/resourceUrl/quill';

export default class TemplateEditor extends LightningElement {
    connectedCallback() {
        Promise.all([
                loadScript(this, quillZip + '/quill.js'),
                loadStyle(this, quillZip + '/quill.snow.css')
            ]
        ).then(() => {
            var editorDiv = this.template.querySelector('.editor-class');
            var q = new Quill(editorDiv , {
                theme : 'snow'
            });



            console.log('html: ', q.container.firstChild.innerHTML);
        });
    }

}