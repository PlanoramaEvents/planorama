<template>
<div class="mr-3" v-if="registrationIntegration">
  <div v-if="!selected.registration_number">
    <!-- Use the redirect to come back to profile -->
    <form :action="registrationIntegration.endpoint + '?redirect=profile'" method="post">
      <input type="hidden" v-model="csrfToken" name="authenticity_token" />
      <b-button variant="info" size="sm" type="submit">Link To Registration</b-button>
    </form>
  </div>
  <div v-if="selected.registration_number">
    <b-button variant="link" @click="notimplemented">Unlink Registration</b-button>
    <dl-person class="align-with-link pt-2" :fields="['registration_number']"></dl-person>
  </div>
</div>
</template>

<script>
import DlPerson from './dl_person.vue'
import { loginIntegrationsMixin } from '@/store/login_integrations.mixin';
import { modelMixinNoProp } from '@/mixins';
import { personModel as model } from '@/store/person.store';
export default {
  name: "RegistrationLink",
  components: { DlPerson },
  mixins: [loginIntegrationsMixin, modelMixinNoProp],
  data: () => ({
    linked: false,
    model
  }),
  methods: {
    notimplemented() {
      window.alert("haven't done this yet.")
    }
  }
}
</script>

<style lang="scss" scoped>
.align-with-link {
  padding: 0 0.75rem;
}
</style>
