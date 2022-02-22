<template>
  <table-vue
    model="agreement"
    :columns="columns"
    ref="agreements-table"
  >
  </table-vue>
</template>

<script>
import TableVue from '../components/table_vue';
import { agreement_columns as columns } from './agreement';
import { mapActions } from 'vuex';
import { NEW_AGREEMENT } from '@/store/agreement.store';

export default {
  name: 'AgreementTable',
  components: {
    TableVue,
  },
  data() {
    return {
      columns
    }
  },
  methods: {
    ...mapActions({newAgreement: NEW_AGREEMENT}),
    init() {
      this.$refs['agreements-table'].fetchPaged()
    }
  }

}
</script>
