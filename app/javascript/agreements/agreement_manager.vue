<template>
  <div>
    <agreement-table></agreement-table>
    <agreement-add></agreement-add>
  </div>
</template>

<script>
import AgreementTable from "@/agreements/agreement_table";
import AgreementAdd from "@/agreements/agreement_add";
export default {
  name: "AgreementManager",
  components: {AgreementAdd, AgreementTable}
}
</script>

<style scoped>

</style>