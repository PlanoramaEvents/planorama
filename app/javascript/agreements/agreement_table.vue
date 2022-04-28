<template>
  <table-vue
    :model="agreement"
    :columns="columns"
    :show-add="false"
    :show-settings="false"
    ref="agreements-table"
  >
  </table-vue>
</template>

<script>
import TableVue from '../components/table_vue';
import { agreement_columns as columns } from './agreement';
import { mapActions } from 'vuex';
import { NEW_AGREEMENT, agreementModel as agreement} from '@/store/agreement.store';

export default {
  name: 'AgreementTable',
  components: {
    TableVue,
  },
  data() {
    return {
      columns,
      agreement
    }
  },
  methods: {
    ...mapActions({newAgreement: NEW_AGREEMENT}),
    init() {
      this.$refs['agreements-table'].fetchPaged()
    }
  // },
  // mounted() {
  //   this.init()
  }
}
</script>
