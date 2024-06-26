<template>
<div class="mr-3" v-if="registrationIntegration && isSelf">
  <div v-if="!currentUserLinked" class="d-flex flex-column align-items-end">
    <!-- Use the redirect to come back to profile -->
    <form :action="registrationIntegration.endpoint + '?redirect=profile'" method="post">
      <input type="hidden" v-model="csrfToken" name="authenticity_token" />
      <disabled-tooltip :disabled="!isSelf" :disabledTooltip="PERSON_DISABLED_LINK">
        <b-button variant="info" size="sm" type="submit" :disabled="!isSelf">Link To Registration</b-button>
      </disabled-tooltip>
    </form>
    <div class="font-italic"><a @click.prevent @keyup.prevent v-b-modal.linkExplanation href="">{{ PROFILE_LINK_EXPLAINATION_TITLE }}</a></div>
  </div>
  <div v-if="currentUserLinked">
    <disabled-tooltip :disabled="!isSelf" :disabledTooltip="PERSON_DISABLED_UNLINK">
      <b-button variant="link" v-b-modal.confirmUnlink :disabled="!isSelf">Unlink Registration</b-button>
    </disabled-tooltip>
    <dl-person class="align-with-link pt-2" :fields="['registration_number']"></dl-person>
  </div>
  <plano-modal id="confirmUnlink" @ok="unlinkPerson" ok-title="Yes" cancel-variant="link">
      <p>{{PERSON_UNLINK_CONFIRMATION_1}}</p>
      <p>{{PERSON_UNLINK_CONFIRMATION_2}}</p>
    </plano-modal>
  <plano-modal id="linkExplanation" :ok-only="true" :title="PROFILE_LINK_EXPLAINATION_TITLE">
    <p>{{ PROFILE_LINK_EXPLAINATION_1 }}</p>
    <p>{{ PROFILE_LINK_EXPLAINATION_2 }}</p>
  </plano-modal>
</div>
</template>

<script>
import DlPerson from './dl_person.vue'
import { loginIntegrationsMixin } from '@/store/login_integrations.mixin';
import { modelMixinNoProp, personSessionMixin, toastMixin } from '@/mixins';
import { personModel as model, UNLINK_PERSON } from '@/store/person.store';
import DisabledTooltip from '@/components/disabled_tooltip.vue';
import {
  PERSON_DISABLED_LINK,
  PERSON_DISABLED_UNLINK,
  PERSON_UNLINK_FAILURE,
  PERSON_UNLINK_SUCCESS,
  PERSON_UNLINK_CONFIRMATION_1,
  PERSON_UNLINK_CONFIRMATION_2,
  PROFILE_LINK_EXPLAINATION_1,
  PROFILE_LINK_EXPLAINATION_2,
  PROFILE_LINK_EXPLAINATION_TITLE,
 } from '@/constants/strings';
import { mapActions } from 'vuex';
import PlanoModal from '@/components/plano_modal.vue';

export default {
  name: "RegistrationLink",
  components: { DlPerson, DisabledTooltip, PlanoModal },
  mixins: [loginIntegrationsMixin, modelMixinNoProp, personSessionMixin, toastMixin],
  data: () => ({
    linked: false,
    model,
    PERSON_DISABLED_LINK,
    PERSON_DISABLED_UNLINK,
    PERSON_UNLINK_CONFIRMATION_1,
    PERSON_UNLINK_CONFIRMATION_2,
    PROFILE_LINK_EXPLAINATION_1,
    PROFILE_LINK_EXPLAINATION_2,
    PROFILE_LINK_EXPLAINATION_TITLE,
  }),
  computed: {
    isSelf() {
      return this.currentUser.id === this.selected.id;
    }
  },
  methods: {
    ...mapActions({
      unlinkPersonStore: UNLINK_PERSON
    }),
    unlinkPerson() {
      this.toastPromise(this.unlinkPersonStore({person: this.selected}), PERSON_UNLINK_SUCCESS, PERSON_UNLINK_FAILURE);
    }
  }
}
</script>

<style lang="scss" scoped>
.align-with-link {
  padding: 0 0.75rem;
}
</style>
