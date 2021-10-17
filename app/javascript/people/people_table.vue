<template>
  <table-vue
    defaultSortBy='name'
    model="person"
    :columns="columns"
  >
  </table-vue>

</template>

<script>
import TableVue from '../components/table_vue';
import { people_columns } from './people';

export default {
  name: 'PeopleTable',
  components: {
    TableVue
    // TooltipOverflow,
  },
  data() {
    return {
      columns: people_columns
    }
  }
}
</script>
