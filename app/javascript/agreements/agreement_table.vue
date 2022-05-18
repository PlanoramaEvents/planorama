<template>
  <table-vue
    :model="agreement"
    :columns="columns"
    :show-add="false"
    :show-settings="false"
    ref="agreements-table"
  >
    <template #cell(title)="{ item }">
      <tooltip-overflow v-if="item.title" :title="item.title">
        {{item.title}}
      </tooltip-overflow>
    </template>
    <template #cell(terms)="{ item }">
      <tooltip-overflow v-if="item.terms" :title="item.terms">
        <span v-html="item.terms"></span>
      </tooltip-overflow>
    </template>
  </table-vue>
</template>

<script>
import TableVue from '../components/table_vue';
import TooltipOverflow from '../shared/tooltip-overflow';
import { agreement_columns as columns } from './agreement';
import { mapActions } from 'vuex';
import { NEW_AGREEMENT, agreementModel as agreement} from '@/store/agreement.store';

export default {
  name: 'AgreementTable',
  components: {
    TableVue,
    TooltipOverflow
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
