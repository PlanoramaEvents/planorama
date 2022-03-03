<template>
  <div>
    <agreement-add></agreement-add>
    <agreement-table
      defaultFilter=''
      ref="agreements-table"
      agreement-selected="onClick"
    ></agreement-table>
  </div>
</template>


<script>
import AgreementTable from "@/agreements/agreement_table";
import AgreementAdd from "@/agreements/agreement_add";

export default {
  name: "AgreementManager",
  components: {AgreementAdd, AgreementTable},
  methods: {
    init() {
      this.$refs['agreements-table'].init();
    },
    onClick(value) {
      alert('in agreement_manager: value='+value);
    }
  }
}
</script>

<style scoped>

</style>
