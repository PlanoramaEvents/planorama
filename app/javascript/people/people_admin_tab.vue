<template>
  <div class="container-fluid">
    <dl class="row">
      <div class="col-12 col-sm-6 col-lg-4">
        <dl-person
          :fields="[
            'registered',
            'registration_number',
            'registration_type',
            'reg_attending_status',
          ]"
          nullText="Unknown"
        >
          <template #registration_number-val-end>
            <edit-button :disabled="!currentUserIsAdmin" v-b-modal.edit-reg-number id="reg-number-edit-button"></edit-button>
            <icon-button
              modal="unlink-confirmation"
              :disabled="!selected.registration_number || !currentUserIsAdmin"
              :tooltip="REG_ID_UNLINK_BUTTON"
              disabledTooltip="You are not an admin or there is no Ticket Number to unlink"
              background="none"
              variant="danger"
              icon="trash-fill"
            ></icon-button>
          </template>
        </dl-person>
        <b-button @click="resyncPerson" variant="primary" :disabled="selected.reg_id == null">Resync Registration</b-button>
      </div>
      <div class="col-12 col-sm-6 col-lg-4">
        <dt>Status</dt>
        <dd class="font-italic ml-2">
          {{ PERSON_CON_STATE[selected.con_state || "not_set"] }}
        </dd>
        <dt>Convention Class</dt>
        <dd class="font-italic ml-2">{{ conventionClasses }}</dd>
      </div>
      <dt class="col-12 mt-2">Comments</dt>
      <dd class="col-12">
        <b-form-textarea v-model="comments"></b-form-textarea>
        <b-button
          class="float-right mt-1"
          @click="patchSelected({ comments })"
          variant="primary"
          >Save Comments</b-button
        >
      </dd>
    </dl>
    <person-edit-reg-number v-if="currentUserIsAdmin"></person-edit-reg-number>
    <plano-modal
      return-focus="#reg-number-edit-button"
      id="unlink-confirmation"
      ok-variant="danger"
      @ok="unlinkPerson()"
      :title="REG_ID_UNLINK_CONFIRMATION_TITLE"
    >
      This will unlink <strong>{{ selected.published_name }}</strong> from Ticket Number {{selected.registration_number}}.
    </plano-modal>
  </div>
</template>

<script>
import personSessionMixin from '../auth/person_session.mixin.js';
import { makeSelectedFieldMixin } from "@/mixins";
import { modelMixinNoProp } from "@/store/model.mixin";
import {
  personModel as model,
  RESYNC_PERSON,
  UNLINK_PERSON,
} from "@/store/person.store";
import {
  PERSON_CON_STATE,
  PERSON_RESYNC_SUCCESS,
  PERSON_RESYNC_FAILURE,
  PERSON_UNLINK_SUCCESS,
  PERSON_UNLINK_FAILURE,
  REG_ID_UNLINK_CONFIRMATION_TITLE,
  REG_ID_UNLINK_BUTTON,
} from "@/constants/strings";
import { mapActions } from "vuex";
import EditModal from "@/components/edit_modal.vue";
import EditButton from "@/components/edit_button.vue";
import PersonEditRegNumber from "./person-edit-reg-number.vue";
import DlPerson from "../profile/dl_person.vue";
import IconButton from '@/components/icon_button.vue';
import PlanoModal from "@/components/plano_modal.vue";

const commentsMixin = makeSelectedFieldMixin("comments");

export default {
  name: "PeopleAdminTab",
  mixins: [modelMixinNoProp, commentsMixin, personSessionMixin],
  components: {
    EditModal,
    EditButton,
    PersonEditRegNumber,
    DlPerson,
    IconButton,
    PlanoModal,
  },
  data: () => ({
    model,
    PERSON_CON_STATE,
    REG_ID_UNLINK_CONFIRMATION_TITLE,
    REG_ID_UNLINK_BUTTON,
  }),
  computed: {
    conventionClasses() {
      return (Object.values(this.selected.convention_roles) || [])
        .map((r) => r.role[0].toUpperCase() + r.role.substring(1))
        .join(", ");
    },
  },
  methods: {
    ...mapActions({
      resyncPersonStore: RESYNC_PERSON,
      unlinkPersonStore: UNLINK_PERSON,
    }),
    unlinkPerson() {
      this.toastPromise(
        this.unlinkPersonStore({ person: this.selected }),
        PERSON_UNLINK_SUCCESS,
        PERSON_UNLINK_FAILURE
      );
    },
    resyncPerson() {
      this.toastPromise(
        this.resyncPersonStore({ person: this.selected }),
        PERSON_RESYNC_SUCCESS,
        PERSON_RESYNC_FAILURE
      );
    },
  },
};
</script>

<style></style>
