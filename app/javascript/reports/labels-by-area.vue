<template>
  <div>
    <h1>Admin Labels and Areas</h1>
    <b-table
      hover bordered responsive small striped
      sticky-header="70vh"    
      :items="labelsByArea"
      :fields="fields"
    >
      <!-- sessions_url(area, label) -->
      <template #head()="scope">
        <div style="writing-mode: sideways-rl;">
          {{ scope.label }}
        </div>
      </template>
      <template #cell()="scope">
        <div v-if="typeof scope.value === 'string'">
          {{scope.value}}
        </div>
        <div v-else-if="typeof scope.value === 'number'">
          <a :href="sessions_url(scope.item.area, scope.field.key)">{{scope.value}}</a>
          <!-- {{ sessions_url(scope.item.area, scope.field.key) }} -->
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
    sessions_url(area, label) {
      let base = "/#/sessions?q="
      // if none then query is "is empty"
      let query = {
          "filter": {
            "op":"All",
            "queries": [
              ["area_list",(area == 'none' ? 'is empty' : 'is'),`${area}`],
              ["labels_list_table.labels_array",(label == 'none' ? 'is empty' : 'is'),`${label}`
              ]
            ]
          },
          "query": {
            "logicalOperator":"All",
            "children":[
              {
                "type":"query-builder-rule",
                "query":{
                  "rule":"area_list",
                  "selectedOperator": (area == 'none' ? 'is empty' : 'is'),
                  "selectedOperand":"Area",
                  "value":`${area}`
                }
              },
              {
                "type":"query-builder-rule",
                "query":{
                  "rule": "labels_list_table.labels_array",
                  "selectedOperator": (label == 'none' ? 'is empty' : 'is'),
                  "selectedOperand":"Admin Labels",
                  "value":`${label}`
                }
              }
            ]
          }
        }
      let qs = encodeURIComponent(JSON.stringify(query))

      return `${base}${qs}`
    },
    init() {
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
