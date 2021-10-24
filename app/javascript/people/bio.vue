<template>
  <div class="bio">
    <div class="row">
      <div class="col-12">
        <b-form-group
          id="bio-text-group"
          label="Biography"
          label-for="bio-text"
          v-if="bio"
        >
          <b-form-textarea
            id="bio-text"
            v-model="bio.bio"
            :disabled="!false"
          >
            {{bio.bio}}
          </b-form-textarea>
        </b-form-group>
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <h2>Social Media</h2>
      </div>
      <div class="col-12 col-sm-4 col-lg-3">
        <!-- <span v-if="!bio.twitter">No twitter info</span>
        <twitter v-model="bio.twitter" :edit="false"></twitter> -->
      </div>
    </div>
  </div>
</template>

<script>
// import Twitter from '../social-media/twitter'
import { mapState } from 'vuex';
// import SaveButton from '../save-button.vue';
// import EditButton from '../edit-button.vue';

export default {
  name: "Bio",
  props: {
    bio: {
      type: Object
    }
  }
  // components: {
  //   Twitter,
  //   // SaveButton,
  //   // EditButton,
  // },
  // computed: {
  //   ...mapState({
  //     person: 'selected',
  //     editable: 'editable'
  //   }),
  //   bio: {
  //     get() {
  //       return this.person.bio ? this.person.bio : {
  //         bio: '',
  //         twitter: null,
  //         photourl: null,
  //         facebook: null,
  //         linkedin: null,
  //         twitch: null,
  //         youtube: null,
  //         instagram: null,
  //         flickr: null,
  //         reddit: null,
  //         othersocialmedia: null,
  //         website: null,
  //       }
  //     },
  //     set(val) {
  //       this.person.bio = val
  //     }
  //   }
  // }
}
</script>

<style>

</style>
