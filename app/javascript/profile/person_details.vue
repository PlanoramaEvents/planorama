<template>
  <div class="d-flex" v-if="editable_person">
    <div class="flex-col w-50 p-2">
      <b-form-group label="Name">
        <b-form-input type="text" v-model="editable_person.name" @blur="onInput"></b-form-input>
      </b-form-group>
      <b-form-group label="Publication Name">
        <b-form-input type="text" v-model="editable_person.pseudonym" @blur="onInput"></b-form-input>
      </b-form-group>
      <email-addresses-editor
        v-model="editable_person"
        model='email_address'
        @input="$emit('input', editable_person)"
      ></email-addresses-editor>
    </div>
    <div class="flex-col w-50 p-2">
      <b-form-group label="At the time of the convention i will be at UTC Offset">
        <timezone-selector v-model="editable_person.timezone" @input="onInput"></timezone-selector>
        <small>
          If you are not sure what your UTC offset will be, or want to verify,
          please go to
          <a target="blank" href="https://www.timeanddate.com/worldclock/meeting.html">
            https://www.timeanddate.com/worldclock/meeting.html
          </a>
          and check by specifying the date of September 1 2022 and your location as well as UTC/GMT
        </small>
      </b-form-group>
      <b-form-checkbox v-model="editable_person.twelve_hour" @input="onInput">
        12 Hour Display
      </b-form-checkbox>
      <b-form-group label="Bio" class="mt-5">
        <plano-editor
          v-model="editable_person.bio"
          type='classic'
          @blur="onInput"
          :disabled="disabled"
        ></plano-editor>
      </b-form-group>
      <b class="mt-3">Social Media</b>
      <validated-social
        :rules="{ regex: /^[a-z0-9_]{1,15}$/i }"
        label="Twitter"
        prepend="@"
        v-model="editable_person.twitter"
        @input="onInput"
        :disabled="disabled"
      ></validated-social>
      <validated-social
        :rules="{ regex: /^[a-z\d.]{5,}$/i }"
        label="Facebook"
        prepend="facebook.com/"
        v-model="editable_person.facebook"
        @input="onInput"
        :disabled="disabled"
      ></validated-social>
      <validated-social
        :rules="{ regex: /^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-zA-Z0-9]+([\-\.]{1}[a-zA-Z0-9]+)*\.[a-zA-Z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ }"
        label="Website"
        prepend="url"
        v-model="editable_person.website"
        @input="onInput"
        :disabled="disabled"
      ></validated-social>
      <validated-social
        :rules="{ regex: /^[a-zA-Z0-9._]+$/ }"
        label="Instagram"
        prepend="instagram.com/"
        v-model="editable_person.instagram"
        @input="onInput"
        :disabled="disabled"
      ></validated-social>
      <validated-social
        :rules="{ regex: /^(#)?[a-zA-Z0-9][\w]{2,24}$/ }"
        label="Twitch"
        prepend="twitch.tv/"
        v-model="editable_person.twitch"
        @input="onInput"
        :disabled="disabled"
      ></validated-social>
      <validated-social
        :rules="{ regex: /UC([-_a-zA-Z0-9]{22})/i }"
        label="YouTube"
        prepend="youtube.com/channel/"
        v-model="editable_person.youtube"
        @input="onInput"
        :disabled="disabled"
      ></validated-social>
      <validated-social
        :rules="{ regex:/^([a-zA-Z0-9._-])+$/ }"
        label="TikTok"
        prepend="@"
        v-model="editable_person.tiktok"
        @input="onInput"
        :disabled="disabled"
      ></validated-social>
      <validated-social
        :rules="{ regex:/^([a-zA-Z0-9.\/_-])+$/ }"
        label="LinkedIn"
        prepend="linkedin.com/in/"
        v-model="editable_person.linkedin"
        @input="onInput"
        :disabled="disabled"
      ></validated-social>
      <simple-social
        label="Other"
        v-model="editable_person.othersocialmedia"
        @input="onInput"
      ></simple-social>
      <!-- We do not appear to cover flickr or reddit in the design -->
    </div>
  </div>
  <!-- <br />
  {{person.pronouns}}
  {{person.gender}}
  {{person.ethnicity}}
  {{person.opted_in}}
  {{person.registered}}
  -->
  <!-- TODO: get from settings the allowed values .... -->
  <!-- {{person.attendance_type}} -->
  <!-- Do we want can stream etc -->
</template>

<script>
import TimezoneSelector from "../components/timezone_selector.vue"
import EmailAddressesEditor from "../components/email_addresses_editor.vue"
import PlanoEditor from '../components/plano_editor'
import ValidatedSocial from '../components/validated_social.vue';
import SimpleSocial from '../social-media/simple-social.vue';
import modelMixin from '../store/model.mixin';

export default {
  name: "PersonDetails",
  components: {
    TimezoneSelector,
    EmailAddressesEditor,
    PlanoEditor,
    ValidatedSocial,
    SimpleSocial
  },
  mixins: [
    modelMixin
  ],
  model: {
    prop: 'person'
  },
  props: {
    person: {
      type: Object,
      required: true
    }
  },
  data: () =>  ({
    editable_person: null,
    disabled: false
  }),
  methods: {
    onInput(arg) {
      this.save(this.editable_person).then(
        (obj) => {
          this.editable_person = obj
          this.$emit('input',this.editable_person)
        }
      )
    }
  },
  mounted() {
    this.editable_person = this.person
  }
}
</script>

<style lang="scss">
</style>
