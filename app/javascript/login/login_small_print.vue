<template>
  <div class="py-2"><small>{{LOGIN_CLICK_TO_AGREE}} <privacy-policy-link></privacy-policy-link>.</small></div>
</template>

<script>
import PrivacyPolicyLink from "@/administration/privacy_policy_link.vue"
import { settingsMixin } from '@/mixins';
import { LOGIN_CLICK_TO_AGREE } from "@/constants/strings";

export default {
  name: "LoginSmallPrint",
  mixins: [settingsMixin],
  components: {
    PrivacyPolicyLink
  },
  computed: {
    conventionName() {
      return this.configByName('convention_name') || ''
    },
    LOGIN_CLICK_TO_AGREE() {
      return LOGIN_CLICK_TO_AGREE(this.conventionName);
    },
  },
}
</script>

<style>

</style>
