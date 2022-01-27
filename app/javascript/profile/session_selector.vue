<template>
  <div class="mb-3">
    <p>
      Put in instructions here ...
    </p>
    <!-- TODO: error messages ??? -->
    <b-table
      hover bordered responsive small striped
      :fields="columns"
      :items="sortedCollection"
      ref="table"
      :no-local-sorting="true"
    >
      <template #cell(title)="{ item }">
        <h4>{{item.title}}</h4>
        <p>{{item.description}}</p>
      </template>
      <template #cell(id)="{ item }">
        <!-- TODO: use session assignment and create/remove etc -->
        <b-form-checkbox
          switch size="lg"
          :value="item.id"
          :unchecked-value="item.id"
          @change="toggleSelectSession"
        >
        </b-form-checkbox>
      </template>
    </b-table>
  </div>
</template>

<script>
// import PeopleTable from './people_table.vue';
// import PeopleSidebar from './people_sidebar.vue';
// import { personModel as model } from '../store/person.store';
import modelMixin from '../store/model.mixin';
import tableMixin from '../store/table.mixin';
import { sessionModel as model } from '@/store/session.store'

// TODO: we need a filter applied to the sessions (only ones ready for selection)
// TODO: we need the area added and the search capability
// TODO: we need to get the assignments for the current person for each session in the result set
// TODO: we need a selector to create/edit the person's assignments
export default {
  name: "SessionSelector",
  mixins: [
    modelMixin,
    tableMixin, // covers pagination and sorting
  ],
  props: {
    // model: model
  },
  data: () => ({
    columns : [
      {
        key: 'title',
        label: 'Session',
        sortable: false
      },
      {
        key: 'id',
        label: 'Select',
        sortable: false
      }
    ]
  }),

  components: {
    // PeopleTable,
    // PeopleSidebar,
  },
  methods: {
    toggleSelectSession(arg) {
      // arg is the id of the selected item
      console.debug('Toggle select this: ', arg)
    }
  }
}
</script>

<style>

</style>
