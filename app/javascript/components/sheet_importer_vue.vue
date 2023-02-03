<template>
  <div>
    <div v-if="exampleUrl">
      Example: <a target="_blank" :href="exampleUrl">{{ exampleUrl }}</a>
    </div>
    <label>File
      <input
        type="file"
        id="files"
        ref="files"
        v-on:change="handleFilesUpload()"
      />
    </label>
    <b-form-checkbox v-model="ignoreFirstLine" >
      This file has a header
    </b-form-checkbox>
    <div v-if="importMessage">
      <div class="border border-secondary d-flex p-2">
        <slot name="import-details" v-bind:importMessage="importMessage">
          {{importMessage}}
        </slot>
      </div>
    </div>
    <div>
      <b-table
        striped
        sticky-header
        thead-class="hidden_header"
        :items="formattedSheetData"
      >
      </b-table>
    </div>
    <div class="d-flex justify-content-end">
      <b-button variant="link" @click="clear">Cancel</b-button>
      <b-button variant="primary" @click="submitData">Save</b-button>
    </div>
  </div>
</template>

<script>
  import XLSX from 'xlsx';
  import {http as axios} from '../http';
  import { spinnerMixin } from '@/store/spinner.mixin';

  export default {
    name: 'SheetImporterVue',
    props: {
      title: String,
      importUrl: String,
      exampleUrl: String
    },
    mixins: [
      spinnerMixin,
    ],
    data() {
      return {
        file: null,
        sheetData: null,
        errorMessage: null,
        importMessage: null,
        ignoreFirstLine: false
      }
    },
    computed: {
      formattedSheetData() {
        // If the row has a problem then we highlight is with "danger"
        if (this.importMessage && this.importMessage.errored_rows) {
          return this.sheetData.map((item, index) => {
            if ( this.importMessage.errored_rows.includes(index) ) {
              item._rowVariant  = 'danger'
            }
            return item
          })
        } else {
          return this.sheetData
        }
      }
    },
    methods: {
      clear() {
        // reset on re-show
        this.file = null
        this.sheetData = null
        this.errorMessage = null
        this.importMessage = null
        this.ignoreFirstLine = false
      },
      submitData(event) {
        event.preventDefault()
        // Get the form data from the modal
        // and send it to the backend as a POST request
        this.showSpinner();
        axios.post(
          this.importUrl,
          {
            ignore_first_line: this.ignoreFirstLine,
            sheet: this.sheetData
          },
          { synchronous: true }
        ).then(
          (res) => {
            this.importMessage = res.data.message
            this.hideSpinner();
          }
        ).catch(
          (err) => {
            if (err.response) {
              this.errorMessage = err.response.data.errors[0].title
              this.$bvToast.toast(
                'Import Failed',
                {
                  variant: 'error',
                  title: this.errorMessage
                }
              );
              this.hideSpinner();
            }
          }
        )
      },
      handleFilesUpload() {
        let uploadedFiles = this.$refs.files.files;
        this.file = uploadedFiles[0]
        var reader = new FileReader();
        reader.onload = this.set_data;
        reader.readAsArrayBuffer(this.file);
      },
      set_data(event) {
        var data = event.target.result;
        data = new Uint8Array(data);
        var workbook = XLSX.read(data, {
          type: "array"
        });

        var first_sheet_name = workbook.SheetNames[0];
        var worksheet = workbook.Sheets[first_sheet_name];
        this.sheetData = XLSX.utils.sheet_to_json(worksheet, {header: 1, defval: ''});
        this.errorMessage = null;
        this.importMessage = null;
      },
      removeFile(key) {
        this.files.splice(key, 1);
      }
    }
  }
</script>
<style>
.hidden_header {
  display: none;
}
</style>
