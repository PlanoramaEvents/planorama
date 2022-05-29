<template>
  <div class="d-flex" v-if="editable_person">
    <div class="d-flex flex-column w-50 p-2">
      <b-form-group label="Name">
        <b-form-input type="text" v-model="editable_person.name" @blur="onInput"></b-form-input>
      </b-form-group>
      <b-form-group label="Pseudonym">
        <b-form-input type="text" v-model="editable_person.pseudonym" @blur="onInput"></b-form-input>
      </b-form-group>
      <email-addresses-editor
        class="mb-4"
        v-model="editable_person"
        model='email_address'
        @input="$emit('input', editable_person)"
      ></email-addresses-editor>
      <b-form-group label="Anyone that should not be assigned to be on a panel with participant">
        <b-form-textarea v-model="editable_person.do_not_assign_with" @blur="onInput"></b-form-textarea>
      </b-form-group>
      <b-form-group label="Permission to be included in a livestreamed program">
          <b-form-radio-group
            stacked
            v-model="editable_person.can_stream"
            @change="onInput"
          >
            <b-form-radio :value="yesLabel.value">{{yesLabel.label}}</b-form-radio>
            <b-form-radio :value="noLabel.value">{{noLabel.label}}</b-form-radio>
            <b-form-radio :value="maybeLabel.value">{{maybeLabel.label}}</b-form-radio>
          </b-form-radio-group>
          <b-textarea v-model="editable_person.can_stream_exceptions" @blur="onInput"></b-textarea>
      </b-form-group>
      <b-form-group label="Permission to be included in a recorded program">
          <b-form-radio-group
            stacked
            v-model="editable_person.can_record"
            @change="onInput"
          >
            <b-form-radio :value="yesLabel.value">{{yesLabel.label}}</b-form-radio>
            <b-form-radio :value="noLabel.value">{{noLabel.label}}</b-form-radio>
            <b-form-radio :value="maybeLabel.value">{{maybeLabel.label}}</b-form-radio>
          </b-form-radio-group>
          <b-textarea v-model="editable_person.can_record_exceptions" @blur="onInput"></b-textarea>
      </b-form-group>
      <b-form-group>
      <b-form-checkbox switch v-model="editable_person.is_local" @change="onInput">Local to the event</b-form-checkbox>
      </b-form-group>
      <b-form-group label="Moderating experience">
        <b-form-textarea v-model="editable_person.moderation_experience" @blur="onInput"></b-form-textarea>
      </b-form-group>

    </div>
    <div class="d-flex flex-column w-50 p-2">
      <div><b>I plan to attend the convention:</b></div>
      <b-form-radio-group
        v-model="editable_person.attendance_type"
        stacked
        @change="attendanceChanged"
      >
        <b-form-radio value="in person">In Person</b-form-radio>
        <b-form-radio value="hybrid">In Person AND Virtually</b-form-radio>
        <b-form-radio value="virtual">Virtually</b-form-radio>
      </b-form-radio-group>
      <b-form-group label="At the time of the convention I will be at UTC Offset">
        <timezone-selector
          v-model="editable_person.timezone"
          @input="onInput"
          class="mb-2"
          :disabled="disabled || editable_person.attendance_type != 'virtual'"
        ></timezone-selector>
        <p>
          Your time now in the selected timezone is <b>{{youTimeNow}}</b>
        </p>
        <small>
          If you are not sure what your UTC offset will be, or want to verify,
          please go to
          <a target="blank" href="https://www.timeanddate.com/worldclock/meeting.html">
            https://www.timeanddate.com/worldclock/meeting.html
          </a>
          and check by specifying the date of September 1 2022 and your location as well as UTC/GMT
        </small>
      </b-form-group>
      <!-- <b-form-checkbox v-model="editable_person.twelve_hour" @input="onInput">
        12 Hour Display
      </b-form-checkbox> -->
      <b-form-group label="Bio">
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
        :message="TWITTER_ID_INVALID_MSG"
      ></validated-social>
      <validated-social
        :rules="{ regex: /^[a-z\d.]{5,}$/i }"
        label="Facebook"
        prepend="facebook.com/"
        v-model="editable_person.facebook"
        @input="onInput"
        :disabled="disabled"
        :message="FACEBOOK_ID_INVALID_MSG"
      ></validated-social>
      <validated-social
        :rules="{ regex: /^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-zA-Z0-9\/]+([\-\.]{1}[a-zA-Z0-9\/]+)*\.[a-zA-Z\/]{2,5}(:[0-9]{1,5})?(\/.*)?$/ }"
        label="Website"
        prepend="url"
        v-model="editable_person.website"
        @input="onInput"
        :disabled="disabled"
        :message="WEBSITE_INVALID_MSG"
      ></validated-social>
      <validated-social
        :rules="{ regex: /^[a-zA-Z0-9._]+$/ }"
        label="Instagram"
        prepend="instagram.com/"
        v-model="editable_person.instagram"
        @input="onInput"
        :disabled="disabled"
        :message="INSTAGRAM_ID_INVALID_MSG"
      ></validated-social>
      <validated-social
        :rules="{ regex: /^(#)?[a-zA-Z0-9][\w]{2,24}$/ }"
        label="Twitch"
        prepend="twitch.tv/"
        v-model="editable_person.twitch"
        @input="onInput"
        :disabled="disabled"
        :message="TWITCH_ID_INVALID_MSG"
      ></validated-social>
      <validated-social
        :rules="{ regex: /^[a-zA-Z0-9\/_]+([\-\.]{1}[a-zA-Z0-9\/_]+)*$/ }"
        label="YouTube"
        prepend="youtube.com/"
        v-model="editable_person.youtube"
        @input="onInput"
        :disabled="disabled"
        :message="YOUTUBE_ID_INVALID_MSG"
      ></validated-social>
      <validated-social
        :rules="{ regex:/^([a-zA-Z0-9._-])+$/ }"
        label="TikTok"
        prepend="@"
        v-model="editable_person.tiktok"
        @input="onInput"
        :disabled="disabled"
        :message="TIKTOK_ID_INVALID_MSG"
      ></validated-social>
      <validated-social
        :rules="{ regex:/^([a-zA-Z0-9.\/_-])+$/ }"
        label="LinkedIn"
        prepend="linkedin.com/in/"
        v-model="editable_person.linkedin"
        @input="onInput"
        :disabled="disabled"
        :message="LINKEDIN_ID_INVALID_MSG"
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

import {
  TWITTER_ID_INVALID_MSG,
  FACEBOOK_ID_INVALID_MSG,
  WEBSITE_INVALID_MSG,
  INSTAGRAM_ID_INVALID_MSG,
  TWITCH_ID_INVALID_MSG,
  YOUTUBE_ID_INVALID_MSG,
  TIKTOK_ID_INVALID_MSG,
  LINKEDIN_ID_INVALID_MSG
} from '../constants/strings';
import settingsMixin from "@/store/settings.mixin";

const { DateTime } = require("luxon");

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
    modelMixin,
    settingsMixin
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
    disabled: false,
    TWITTER_ID_INVALID_MSG,
    FACEBOOK_ID_INVALID_MSG,
    WEBSITE_INVALID_MSG,
    INSTAGRAM_ID_INVALID_MSG,
    TWITCH_ID_INVALID_MSG,
    YOUTUBE_ID_INVALID_MSG,
    TIKTOK_ID_INVALID_MSG,
    LINKEDIN_ID_INVALID_MSG
  }),
  computed: {
    youTimeNow() {
      if (this.editable_person.timezone) {
        return DateTime.now().setZone(this.editable_person.timezone).toLocaleString(DateTime.TIME_SIMPLE)
      }
      return 'Not Set'
    },
    yesLabel() {
      return this.currentSettings?.yesnomaybe?.find(ynm => ynm.value === "yes") || {
        label: "Yes",
        value: "yes"
      }
    },
    noLabel() {
      return this.currentSettings?.yesnomaybe?.find(ynm => ynm.value === "no") || {
        label: "No",
        value: "no"
      }
    },
    maybeLabel() {
      return this.currentSettings?.yesnomaybe?.find(ynm => ynm.value === "maybe") || {
        label: "Yes, except for items focused on the topics listed below.",
        value: "maybe"};
    },
  },
  methods: {
    attendanceChanged(arg) {
      // console.debug("***** ATT CHNAGED", arg)
      this.save(this.editable_person).then(
        (obj) => {
          this.editable_person = obj
          this.$emit('input',this.editable_person)
        }
      )
    },
    onInput(arg) {
      this.save(this.editable_person).then(
        (obj) => {
          console.log(obj);
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
