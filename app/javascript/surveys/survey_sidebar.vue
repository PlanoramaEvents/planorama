<template>
  <sidebar-vuex>
    <template #sidebar-header v-if="survey">
      <h1 class="title">{{ survey.name }}</h1>
    </template>
    <template #sidebar-content class="survey" v-if="survey">
      <div class="row">
        <div class="col-12">
          <span>Closed</span>
          <b-form-checkbox inline v-model="survey.public" switch @change="save" >
            Published
          </b-form-checkbox>
          <span v-if="survey.public">on TODO TRACK PUBLISH DATE </span>
        </div>
        <div class="col-12">
        </div>
      </div>
    </template>
  </sidebar-vuex>
</template>

<script>
import { mapActions, mapState } from 'vuex';
import { SAVE } from '../model.store';
import SidebarVuex from '../sidebar_vuex';

export default {
  name: 'SurveySidebar',
  components: {
    SidebarVuex
  },
  computed: mapState({
    survey: 'selected'
  }),
  methods: mapActions({
    save: SAVE
  })
}
</script>
