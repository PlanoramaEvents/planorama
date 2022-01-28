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
        <!-- {{ item.my_assignment }} -->
      </template>
      <template #cell(id)="{ item }">
        <interest-indicator :value="item.my_assignment"></interest-indicator>
      </template>
    </b-table>
  </div>
</template>

<script>
import modelMixin from '../store/model.mixin';
import tableMixin from '../store/table.mixin';
import InterestIndicator from './interest_indicator.vue'
import { sessionModel as model } from '@/store/session.store'

// TODO: we need a filter applied to the sessions (only ones ready for selection)
// TODO: we need the area added and the search capability
// TODO: we need to get the assignments for the current person for each session in the result set
// TODO: we need a selector to create/edit the person's assignments
export default {
  name: "SessionSelector",
  components: {
    InterestIndicator
  },
  mixins: [
    modelMixin,
    tableMixin // covers pagination and sorting
  ],
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
  })
}
</script>

<style>

</style>
