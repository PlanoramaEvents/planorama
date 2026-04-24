<template>
  <div>
    <h1>Admin Labels and Areas</h1>
    <b-table
      hover bordered responsive small striped
      sticky-header="70vh"    
      :items="labelsByArea"
      :fields="fields"
    >
      <template #head()="scope">
        <div style="writing-mode: sideways-rl;">
          {{ scope.label }}
        </div>
      </template>
    </b-table>
  </div>
</template>

<script>
import {http} from "@/http"

export default {
  name: "LabelsByArea",
  data: () => ({
    fields: [],
    labelsByArea: []
  }),
  methods: {
    init() {
      console.debug("GET THE TTTT")
      http.get("/session/labels_by_area").then(
        (res) => {
          let header = res.data.header
          header[0] = {key: header[0], stickyColumn: true, isRowHeader: true}
          this.fields = header
          this.labelsByArea = res.data.labels_by_area
        }).catch(
        (error) => {
          // If we can not get the settings, then leave them empty
        })
    }
  },
  mounted() {
    this.init()
  }
}

</script>
