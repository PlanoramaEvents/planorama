<template>
  <sidebar-vuex>
    <template #header v-if="survey">
      <h1 class="title">{{ survey.name }}</h1>
    </template>
    <template #content class="survey" v-if="survey">
      <div class="row">
        <div class="col-6">
          <span class="mr-2">Closed</span>
          <b-form-checkbox inline v-model="survey.public" switch @change="save" >
            Published
          </b-form-checkbox>
          <span v-if="survey.public">on ????</span>
        </div>
        <div class="col-6">
          <b-form-checkbox inline v-model="survey.anonymous" switch @change="save">
            Anonymous
          </b-form-checkbox>
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
    save() {
      this.$store.dispatch(SAVE, this.survey)
    }
  })
}
</script>
