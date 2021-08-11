<template>
  <footer class="d-flex justify-content-center">
    <terms-of-use-link></terms-of-use-link>
    <div class="silly-spacer"></div>
    <privacy-policy-link></privacy-policy-link>
  </footer>
</template>

<script>
import TermsOfUseLink from '../administration/terms_of_use_link.vue';
import PrivacyPolicyLink from '../administration/privacy_policy_link.vue';

export default {
  name: 'BottomNavbar',
  components: {
    PrivacyPolicyLink,
    TermsOfUseLink,
  }
}
</script>

<style lang="scss" scoped>
  .silly-spacer {
    width: 5rem;
  }
</style>
