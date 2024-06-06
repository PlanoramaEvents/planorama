<template>
  <div class="d-flex" v-if="selected">
    <div class="d-flex flex-column w-50 p-2 mr-3">
      <div>
        <h5>Identity</h5>
        <div class="d-flex justify-content-between">
          <dl-person :fields="['name', 'pseudonym', 'registration_number']" :overrides="{'null': {registration_number: 'Unknown'}}"></dl-person>
          <!-- <registration-link v-if="!readOnly"></registration-link> -->
          <!-- <dl-person class="mr-3" :fields="['registration_number']"></dl-person> -->
        </div>
      </div>
      <div v-if="readOnly">
        <h5>Emails</h5>
        <dl>
          <dt>Primary email (login)</dt>
          <dd class="font-italic ml-2">{{selected.primary_email.email}}</dd>
          <dt>Additional emails</dt>
          <dd v-for="email in additionalEmails" class="ml-2 font-italic" :key="email.id">{{email.email}}</dd>
          <dd v-if="!additionalEmails.length" class="ml-2 font-italic text-muted">None</dd>
        </dl>
      </div>
      <email-addresses-editor
        v-if="!readOnly"
        class="mb-4"
        v-model="selected"
        model='email_address'
        @input="$emit('input', selected)"
      ></email-addresses-editor>
      <h5>Additional Information <edit-button v-b-modal.person-misc-modal v-if="!readOnly && showAdditionalInfo"></edit-button></h5>
      <dl-person :fields="miscFields" v-if="showAdditionalInfo">
        <template #can_stream-val>{{can_stream_label}}</template>
        <template #can_record-val>{{can_record_label}}</template>
      </dl-person>
      <div v-else>Coming Soon</div>
    </div>
    <div class="d-flex flex-column w-50 p-2">
      <div v-if="eventVirtual && readOnly">
        <h5>Online</h5>
        <dl-person :fields="['attendance_type', 'timezone']">
          <template #attendance_type-val="{value}">{{PERSON_ATTENDANCE_TYPE[value]}}</template>
        </dl-person>
      </div>
      <div v-if="eventVirtual && !readOnly">
        <h5>Online</h5>
        <div><b>I plan to attend the convention:</b></div>
        <b-form-radio-group
          v-model="selected.attendance_type"
          stacked
          @change="saveSelected()"
          :options="attendanceTypeOptions"
        >
        </b-form-radio-group>
        <b-form-group label="At the time of the convention I will be at UTC Offset">
          <timezone-selector
            v-model="selected.timezone"
            @input="saveSelected()"
            class="mb-2"
            :disabled="disabled || selected.attendance_type != 'virtual'"
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
            and check by specifying the date of first day of the convention and your location as well as UTC/GMT
          </small>
        </b-form-group>
      </div>
      <!-- <b-form-checkbox v-model="selected.twelve_hour" @input="saveSelected()">
        12 Hour Display
      </b-form-checkbox> -->
      <h5>Bio <edit-button v-b-modal.person-bio-modal v-if="!readOnly"></edit-button></h5>
      <div class="ml-2" v-html="selected.bio"></div>
      <h5 class="mt-3">Social Media <edit-button v-b-modal.person-social-modal v-if="!readOnly"></edit-button></h5>
      <dl-person :fields="socialFields"></dl-person>
    </div>
    <person-edit-modal id="person-bio-modal" :person="selected" :data="{bio: null}">
      <template #modal-title>Edit Bio - {{selected.published_name}}</template>
      <template #default="{fields}">
        <plano-editor
          v-model="fields.bio"
          type='classic'
        ></plano-editor>
      </template>
    </person-edit-modal>
    <person-edit-modal id="person-misc-modal" :person="selected" :data="miscData" :validate="true">
      <template #modal-title>Edit Additional Info - {{selected.published_name}}</template>
      <template #default="{fields}">
        <validation-provider name="Anyone that should not be assigned with" v-if="!isHidden('do_not_assign_with')">
          <b-form-group :label="PROFILE_FIELD_LABELS.do_not_assign_with">
            <!-- TODO change edit permissions to sensitive data tickybox -->
            <b-form-textarea v-if="canEditSensitiveInfo" v-model="fields.do_not_assign_with"></b-form-textarea>
            <b-form-textarea v-if="!canEditSensitiveInfo" disabled value="Restricted"></b-form-textarea>
          </b-form-group>
        </validation-provider>
        <validation-provider name="Demographic categories to not discuss" v-if="!isHidden('excluded_demographic_categories')">
          <b-form-group :label="PROFILE_FIELD_LABELS.excluded_demographic_categories">
            <!-- TODO change edit permissions to sensitive data tickybox -->
            <b-form-textarea v-if="canEditSensitiveInfo" v-model="fields.excluded_demographic_categories"></b-form-textarea>
            <b-form-textarea v-if="!canEditSensitiveInfo" disabled value="Restricted"></b-form-textarea>
          </b-form-group>
        </validation-provider>

        <validation-provider name="Sharing preferences" v-if="!isHidden('can_share')">
          <b-form-group :label="PROFILE_FIELD_LABELS.can_share">
            <b-form-radio-group
              stacked
              v-model="fields.can_share"
            >
              <b-form-radio :value="true">{{yesLabel.label}}</b-form-radio>
              <b-form-radio :value="false">{{noLabel.label}}</b-form-radio>
            </b-form-radio-group>
          </b-form-group>
        </validation-provider>

        <b-form-group :label="PROFILE_FIELD_LABELS.can_stream" v-if="!isHidden('can_stream')">
          <validation-provider>
            <b-form-radio-group
              stacked
              v-model="fields.can_stream"
            >
              <b-form-radio :value="yesLabel.value">{{yesLabel.label}}</b-form-radio>
              <b-form-radio :value="noLabel.value">{{noLabel.label}}</b-form-radio>
              <b-form-radio :value="maybeLabel.value">{{maybeLabel.label}}</b-form-radio>
            </b-form-radio-group>
          </validation-provider>
          <validation-provider>
            <b-textarea v-model="fields.can_stream_exceptions"></b-textarea>
          </validation-provider>
        </b-form-group>
        <b-form-group :label="PROFILE_FIELD_LABELS.can_record" v-if="!isHidden('can_record')">
          <validation-provider>
            <b-form-radio-group stacked v-model="fields.can_record" >
              <b-form-radio :value="yesLabel.value">{{yesLabel.label}}</b-form-radio>
              <b-form-radio :value="noLabel.value">{{noLabel.label}}</b-form-radio>
              <b-form-radio :value="maybeLabel.value">{{maybeLabel.label}}</b-form-radio>
            </b-form-radio-group>
          </validation-provider>
          <validation-provider>
            <b-textarea v-model="fields.can_record_exceptions"></b-textarea>
          </validation-provider>
        </b-form-group>
        <validation-provider v-if="!isHidden('is_local')">
          <b-form-group>
          <b-form-checkbox switch v-model="fields.is_local">{{ PROFILE_FIELD_LABELS.is_local }}</b-form-checkbox>
          </b-form-group>
        </validation-provider>
        <validation-provider v-if="!isHidden('moderation_experience')">
        <b-form-group :label="PROFILE_FIELD_LABELS.moderation_experience">
          <b-form-textarea v-model="fields.moderation_experience"></b-form-textarea>
        </b-form-group>
        </validation-provider>
        <validation-provider v-if="!isHidden('needs_accommodations')">
          <b-form-group :label="PROFILE_FIELD_LABELS.needs_accommodations">
            <b-form-radio-group
              stacked
              v-model="fields.needs_accommodations"
            >
              <b-form-radio :value="true">{{yesLabel.label}}</b-form-radio>
              <b-form-radio :value="false">{{noLabel.label}}</b-form-radio>
            </b-form-radio-group>
          </b-form-group>
        </validation-provider>
        <validation-provider v-if="!isHidden('accommodations')">
          <b-form-group :label="PROFILE_FIELD_LABELS.accommodations">
            <b-textarea v-model="fields.accommodations"></b-textarea>
          </b-form-group>
        </validation-provider>
      </template>
    </person-edit-modal>
    <person-edit-modal id="person-social-modal" :person="selected" :data="socialsData" :validate="true">
      <template #modal-title>Edit Socials - {{selected.published_name}}</template>
      <template #default="{fields}">
        <simple-social
          v-if="!isHidden('facebook')"
          :rules="{min: 5, regex: /^[a-z\d.]{5,}$/i }"
          :label="PROFILE_FIELD_LABELS.facebook"
          prepend="facebook.com/"
          v-model="fields.facebook"
          :disabled="disabled"
        ></simple-social>
        <simple-social
          v-if="!isHidden('website')"
          :rules="{ regex: /^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-zA-Z0-9\/]+([\-\.]{1}[a-zA-Z0-9\/]+)*\.[a-zA-Z\/]{2,5}(:[0-9]{1,5})?(\/.*)?$/ }"
          :label="PROFILE_FIELD_LABELS.website"
          prepend="url"
          v-model="fields.website"
          :disabled="disabled"
        ></simple-social>
        <simple-social
          v-if="!isHidden('instagram')"
          :rules="{ regex: /^[a-zA-Z0-9._]+$/ }"
          :label="PROFILE_FIELD_LABELS.instagram"
          prepend="instagram.com/"
          v-model="fields.instagram"
          :disabled="disabled"
        ></simple-social>
        <simple-social
          v-if="!isHidden('twitch')"
          :rules="{ regex: /^(#)?[a-zA-Z0-9][\w]{2,24}$/ }"
          :label="PROFILE_FIELD_LABELS.twitch"
          prepend="twitch.tv/"
          v-model="fields.twitch"
          :disabled="disabled"
        ></simple-social>
        <simple-social
          v-if="!isHidden('youtube')"
          :rules="{ regex: /^[a-zA-Z0-9\/_]+([\-\.]{1}[a-zA-Z0-9\/_]+)*$/ }"
          :label="PROFILE_FIELD_LABELS.youtube"
          prepend="youtube.com/"
          v-model="fields.youtube"
          :disabled="disabled"
        ></simple-social>
        <simple-social
          v-if="!isHidden('tiktok')"
          :rules="{ regex:/^([a-zA-Z0-9._-])+$/ }"
          :label="PROFILE_FIELD_LABELS.tiktok"
          prepend="@"
          v-model="fields.tiktok"
          :disabled="disabled"
        ></simple-social>
        <simple-social
          v-if="!isHidden('linkedin')"
          :rules="{ regex:/^([a-zA-Z0-9.\/_-])+$/ }"
          :label="PROFILE_FIELD_LABELS.linkedin"
          prepend="linkedin.com/in/"
          v-model="fields.linkedin"
          :disabled="disabled"
        ></simple-social>
        <simple-social
          v-if="!isHidden('bsky')"
          :label="PROFILE_FIELD_LABELS.bsky"
          prepend="@"
          v-model="fields.bsky"
          :disabled="disabled"
        ></simple-social>
        <simple-social
          v-if="!isHidden('fediverse')"
          :label="PROFILE_FIELD_LABELS.fediverse"
          :rules="{ regex: /^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-zA-Z0-9\/]+([\-\.]{1}[a-zA-Z0-9\/]+)*\.[a-zA-Z\/]{2,5}(:[0-9]{1,5})?(\/.*)?$/ }"
          prepend="url"
          v-model="fields.fediverse"
          :disabled="disabled"
        ></simple-social>
        <simple-social
          v-if="!isHidden('twitter')"
          :label="PROFILE_FIELD_LABELS.twitter"
          :rules="{min: 1, max: 15, regex: /^[a-z0-9_]{1,15}$/i}"
          prepend="@"
          v-model="fields.twitter"
          :disabled="disabled"
        ></simple-social>
        <simple-social
          v-if="!isHidden('othersocialmedia')"
          :label="PROFILE_FIELD_LABELS.othersocialmedia"
          v-model="fields.othersocialmedia"
        ></simple-social>
      </template>
    </person-edit-modal>
  </div>
</template>

<script>
import TimezoneSelector from "@/components/timezone_selector.vue"
import EmailAddressesEditor from "@/components/email_addresses_editor.vue"
import PlanoEditor from '@/components/plano_editor'
import SimpleSocial from '../social-media/simple-social.vue';
import EditButton from '@/components/edit_button.vue';
import PersonEditModal from './person_edit_modal.vue';
import RegistrationLink from './registration_link.vue';
import DlPerson from './dl_person.vue';
import { ValidationProvider } from 'vee-validate';

import {
  PERSON_ATTENDANCE_TYPE,
  PROFILE_FIELD_LABELS
} from '../constants/strings';
import settingsMixin from "@/store/settings.mixin";
import { modelMixinNoProp } from '@/store/model.mixin';
import { personModel as model } from "@/store/person.store";
import { DateTime } from "luxon";
import personSessionMixin from '@/auth/person_session.mixin';
import { eventVirtualMixin } from '@/shared/event-virtual.mixin';
import { peopleHiddenFieldsMixin } from '@/configurations/people_hidden_fields.mixin';

export default {
  name: "PersonDetails",
  props: {
    readOnly: {
      type: Boolean,
      default: false
    }
  },
  components: {
    TimezoneSelector,
    EmailAddressesEditor,
    PlanoEditor,
    SimpleSocial,
    PersonEditModal,
    EditButton,
    DlPerson,
    ValidationProvider,
    RegistrationLink,
  },
  mixins: [
    settingsMixin,
    modelMixinNoProp,
    personSessionMixin,
    eventVirtualMixin,
    peopleHiddenFieldsMixin
  ],
  data: () =>  ({
    disabled: false,
    PERSON_ATTENDANCE_TYPE,
    model,
    miscData: {
      do_not_assign_with: null,
      excluded_demographic_categories: null,
      can_share: null,
      can_stream: null,
      can_stream_exceptions: null,
      can_record: null,
      can_record_exceptions: null,
      is_local: null,
      moderation_experience: null,
      needs_accommodations: null,
      accommodations: null,
    },
    socialsData: {
      facebook: null,
      website: null,
      instagram: null,
      twitch: null,
      youtube: null,
      tiktok: null,
      linkedin: null,
      bsky: null,
      fediverse: null,
      twitter: null,
      othersocialmedia: null
    },
    PROFILE_FIELD_LABELS,
  }),
  computed: {
    showAdditionalInfo() {
      return (this.configByName('profile_show_info_demographic_community') !== "false")
    },
    attendanceTypeOptions() {
      return Object.entries(PERSON_ATTENDANCE_TYPE).map(([key, value]) => ({text: value, value: key}))
    },
    socialFields() {
      return this.filterFieldList(Object.keys(this.socialsData));
    },
    miscFields() {
      return this.filterFieldList(Object.keys(this.miscData));
    },
    can_stream_label() {
      switch(this.selected.can_stream) {
        case this.noLabel.value:
          return this.noLabel.label;
        case this.yesLabel.value:
          return this.yesLabel.label;
        case this.maybeLabel.value:
          return this.maybeLabel.label;
        default:
          return this.selected.can_stream;
      }
    },
    can_record_label() {
      switch(this.selected.can_record) {
        case this.noLabel.value:
          return this.noLabel.label;
        case this.yesLabel.value:
          return this.yesLabel.label;
        case this.maybeLabel.value:
          return this.maybeLabel.label;
        default:
          return this.selected.can_record;
      }

    },
    youTimeNow() {
      if (this.selected.timezone) {
        return DateTime.now().setZone(this.selected.timezone).toLocaleString(DateTime.TIME_SIMPLE)
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
    canEditSensitiveInfo() {
      // TODO in the future use the sensitive data permission instead of the admin setting
      return this.currentUserIsAdmin || this.currentUser.id === this.selected.id;
    },
    additionalEmails() {
      return Object.values(this.selected.email_addresses).filter(e => !e.isdefault)
    }
  },
}
</script>

<style lang="scss">
</style>
