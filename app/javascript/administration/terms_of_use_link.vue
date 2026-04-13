<template>
    <a :href="termsOfUseLink" target="_blank">Terms of Use</a>
</template>

<script>
import { settingsMixin } from '@/mixins';

export default {
    name: "TermsOfUseLink",
    mixins: [
        settingsMixin
    ],
    computed: {
        termsOfUseLink() {
            return this.configByName('terms_of_use_link') || "https://planoramaevents.github.io/planorama/tandc"; 
        }
    }
}
</script>
