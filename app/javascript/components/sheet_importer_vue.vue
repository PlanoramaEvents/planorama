<template>
  <div>
    <label>File
      <input
        type="file"
        id="files"
        ref="files"
        v-on:change="handleFilesUpload()"
      />
    </label>
    <b-form-checkbox
      v-model="ignoreFirstLine"
      value="true"
      unchecked-value="false"
    >
      Ignore the first line.
    </b-form-checkbox>
    <div>
      <b-table
        striped
        sticky-header
        thead-class="hidden_header"
        :items="sheetData"
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
  import Vue from 'vue';
  import XLSX from 'xlsx';
  import {http as axios} from '../http';

  export default {
    name: 'SheetImporterVue',
    props: {
      title: String,
      importUrl: String
    },
    data() {
      return {
        file: null,
        sheetData: null,
        errorMessage: null,
        ignoreFirstLine: false
      }
    },
    methods: {
      clear() {
        // reset on re-show
        this.file = this.sheetData = this.errorMessage = null
        this.ignoreFirstLine = false
      },
      submitData(event) {
        event.preventDefault()
        // Get the form data from the modal
        // and send it to the backend as a POST request
        axios.post(
          this.importUrl,
          {
            'ignore_first_line': this.ignoreFirstLine,
            sheet: this.sheetData
          },
          { synchronous: true }
        ).then(
          (res) => {
            // console.debug('********* IMPORT DONE: ', res.data)
            this.$bvToast.toast(res.data.message, {
              variant: 'success',
              title: 'People Imported'
            })

            this.$bvModal.hide('sheet-import-modal')
          }
        ).catch(
          (err) => {
            // console.debug('********* IMPORT ERROR: ', err)
            if (err.response) {
              this.errorMessage = err.response.data.errors[0].title
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
        this.sheetData = XLSX.utils.sheet_to_json(worksheet, {header: 1});
        this.errorMessage = null;
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
