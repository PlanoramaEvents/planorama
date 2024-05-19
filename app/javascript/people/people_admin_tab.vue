<template>
  <div class="container-fluid">
        <dl class="row">
          <div class="col-12 col-sm-6 col-lg-4">
            <dt>Status</dt>
            <dd class="font-italic ml-2">{{PERSON_CON_STATE[selected.con_state || 'not_set']}}</dd>
            <dt>Registered</dt>
            <dd class="font-italic ml-2">{{selected.registered ? 'Yes' : 'No'}}</dd>
            <dt>Registration ID</dt>
            <dd class="font-italic ml-2">{{selected.registration_number || 'Unknown'}}</dd>
            <b-button @click="resyncPerson" variant="primary" :disabled="selected.reg_id == null">Resync Registration</b-button>            
          </div>
          <div class="col-12 col-sm-6 col-lg-4">
            <dt>Convention Class</dt>
            <dd class="font-italic ml-2">{{conventionClasses}}</dd>
          </div>
          <dt class="col-12 mt-2">Comments</dt>
          <dd class="col-12">
            <b-form-textarea v-model="comments"></b-form-textarea>
            <b-button class="float-right mt-1" @click="patchSelected({comments})" variant="primary">Save Comments</b-button>
          </dd>
        </dl>
  </div>
</template>

<script>
import { makeSelectedFieldMixin } from '@/mixins'
import { modelMixinNoProp } from '@/store/model.mixin';
import { personModel as model ,RESYNC_PERSON } from '@/store/person.store';
import { PERSON_CON_STATE, PERSON_RESYNC_SUCCESS, PERSON_RESYNC_FAILURE } from '@/constants/strings';
import { mapActions } from 'vuex';

const commentsMixin = makeSelectedFieldMixin('comments');

export default {
  name: 'PeopleAdminTab',
  mixins: [
    modelMixinNoProp,
    commentsMixin
  ],
  data: () => ({
    model,
    PERSON_CON_STATE
  }),
  computed: {
    conventionClasses() {
      return (Object.values(this.selected.convention_roles) || []).map(r => r.role[0].toUpperCase() + r.role.substring(1)).join(', ')
    }
  },
  methods: {
    ...mapActions({
      resyncPersonStore: RESYNC_PERSON
    }),
    resyncPerson() {
      this.toastPromise(this.resyncPersonStore({ person: this.selected }), PERSON_RESYNC_SUCCESS, PERSON_RESYNC_FAILURE);
    }
  },
}
</script>

<style>

</style>
