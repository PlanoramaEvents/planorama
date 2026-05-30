<template>
  <div>
    <b-button variant="link" @click="back">Back</b-button>
    <h2>Admin Label Counts By Area</h2>
    <b-table
      hover bordered responsive small striped
      sticky-header="70vh"    
      :items="labelsByArea"
      :fields="fields"
    >
      <!-- sessions_url(area, label) -->
      <template #head()="scope">
        <div class="sideways-text">
          <span :title="scope.label">{{ scope.label }}</span>
        </div>
      </template>
      <template #cell()="scope">
        <div v-if="typeof scope.value === 'string' && scope.value">
          {{scope.value}}
        </div>
        <div v-else-if="typeof scope.value === 'number'">
          <a :href="sessions_url(scope.item.area, scope.field.key)">{{scope.value}}</a>
          <!-- {{ sessions_url(scope.item.area, scope.field.key) }} -->
        </div>
        <div v-else>
          <span class="text-muted">&mdash;</span>
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
    back() {
      this.$router.push('/reports');
    },
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

<style lang="css" scoped>
.sideways-text {
  writing-mode: sideways-lr;
}

th:first-of-type .sideways-text, th:last-of-type .sideways-text {
  writing-mode: unset;
}
</style>
