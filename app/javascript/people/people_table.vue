<template>
  <table-vue
    @new="onNew"
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
  },
  methods: {
    // ...mapActions({newSurvey: NEW_SURVEY}),
    // previewLink(item) {
    //   return `/surveys/${item.id}/preview`;
    // },
    // surveyLink(item) {
    //   // TODO add authenticity key to stop robots?
    //   return `/surveys/${item.id}`;
    // },
    onNew() {
      console.debug("**** NEW PERSON")
      // this.newSurvey().then((survey) => {
      //   this.$router.push({path: `/edit/${survey.id}`})
      // });
    }
  }
}
</script>
