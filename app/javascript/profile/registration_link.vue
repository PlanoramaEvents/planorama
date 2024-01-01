<template>
<div class="mr-3" v-if="registrationIntegration">
  <div v-if="!selected.registration_number">
    <!-- Use the redirect to come back to profile -->
    <form :action="registrationIntegration.endpoint + '?redirect=profile'" method="post">
      <input type="hidden" v-model="csrfToken" name="authenticity_token" />
      <disabled-tooltip :disabled="!isSelf" :disabledTooltip="PERSON_DISABLED_LINK">
        <b-button variant="info" size="sm" type="submit" :disabled="!isSelf">Link To Registration</b-button>
      </disabled-tooltip>
    </form>
  </div>
  <div v-if="selected.registration_number">
    <disabled-tooltip :disabled="!isSelf" :disabledTooltip="PERSON_DISABLED_UNLINK">
      <b-button variant="link" v-b-modal.confirmUnlink :disabled="!isSelf">Unlink Registration</b-button>
    </disabled-tooltip>
    <dl-person class="align-with-link pt-2" :fields="['registration_number']"></dl-person>
  </div>
  <b-modal id="confirmUnlink" @ok="unlinkPerson" ok-title="Yes" cancel-variant="link" title="Unlink registration?">
      <p>ARE YOU SURE????!1?</p>
    </b-modal>
</div>
</template>

<script>
import DlPerson from './dl_person.vue'
import { loginIntegrationsMixin } from '@/store/login_integrations.mixin';
import { modelMixinNoProp, personSessionMixin } from '@/mixins';
import { personModel as model } from '@/store/person.store';
import DisabledTooltip from '@/components/disabled_tooltip.vue';
import { PERSON_DISABLED_LINK, PERSON_DISABLED_UNLINK } from '@/constants/strings';
import { mapActions } from 'vuex';
export default {
  name: "RegistrationLink",
  components: { DlPerson, DisabledTooltip },
  mixins: [loginIntegrationsMixin, modelMixinNoProp, personSessionMixin],
  data: () => ({
    linked: false,
    model,
    PERSON_DISABLED_LINK,
    PERSON_DISABLED_UNLINK
  }),
  computed: {
    isSelf() {
      return this.currentUser.id === this.selected.id;
    }
  },
  methods: {
    ...mapActions({
      delete: 'jv/delete'
    }),
    notimplemented() {
      window.alert("haven't done this yet.")
    },
    unlinkPerson() {
      // TODO WHY DOESN"T THIS WORK
      this.delete(`/person/${this.selected.id}/unlink_registration`).then(data => {
          console.debug("*********DATA", data)
          // do i need this
        })
    }
  }
}
</script>

<style lang="scss" scoped>
.align-with-link {
  padding: 0 0.75rem;
}
</style>
