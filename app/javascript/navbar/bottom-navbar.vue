<template>
  <footer :class="['d-flex', 'justify-content-center', {'not-production': currentSettings.env !== 'production'}]">
    <terms-of-use-link></terms-of-use-link>
    <div class="silly-spacer"></div>
    <privacy-policy-link></privacy-policy-link>
  </footer>
</template>

<script>
import TermsOfUseLink from '../administration/terms_of_use_link.vue';
import PrivacyPolicyLink from '../administration/privacy_policy_link.vue';
import { settingsMixin } from '@/mixins';

export default {
  name: 'BottomNavbar',
  components: {
    PrivacyPolicyLink,
    TermsOfUseLink,
  },
  mixins: [
    settingsMixin
  ]
}
</script>

<style lang="scss" scoped>
@import '../stylesheets/style.scss';
.silly-spacer {
  width: 5rem;
}
footer {
  background: $color-primary-4;
  height: 50px;
  width: 100%;
  position: absolute;
  bottom: 0px;
  padding: 10px;

  a {
    color: white;

    &:hover {
      color: white;
      text-decoration: underline;
    }
  }
}
</style>
