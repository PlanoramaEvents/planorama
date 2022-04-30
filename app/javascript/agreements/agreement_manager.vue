<template>
  <div>
    <div style="padding-bottom: 25px">
      <agreement-table
        defaultFilter=''
        ref="agreements-table"
      ></agreement-table>
    </div>
    <div style="border: solid">
      <agreement-editor ref="agreementEditor" @saved="init"/>
    </div>
  </div>
</template>


<script>
import AgreementTable from "@/agreements/agreement_table";
import AgreementEditor from "@/agreements/agreement_editor";
import modelMixin from '../store/model.mixin'
import {agreement_columns as columns} from "@/agreements/agreement";

export default {
  name: "AgreementManager",
  components: {AgreementEditor, AgreementTable},
  mixins: [
    modelMixin,
  ],
  data() {
    return {
      columns,
    }
  },
  watch: {
    "selected" : function(val) {
      this.$refs.agreementEditor.setAgreementData(val);
    }
  },
  methods: {
    init() {
      this.$refs['agreements-table'].init();
    },
  }
}
</script>

<style scoped>

</style>
