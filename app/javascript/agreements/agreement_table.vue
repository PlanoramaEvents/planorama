<template>
  <div>
  {{selected}}
  <table-vue
    model="agreement"
    :columns="columns"
    ref="agreements-table"
  >
  </table-vue>
  </div>
</template>

<script>
import TableVue from '../components/table_vue';
import { agreement_columns as columns } from './agreement';
import { mapActions } from 'vuex';
import { NEW_AGREEMENT, selected } from '@/store/agreement.store';

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
      alert(this.se)
      this.$refs['agreements-table'].fetchPaged()
    },
    onClick(value) {
      alert('in agreement_table: value='+value);
    }
  }

}
</script>
