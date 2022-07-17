<template>
  <div v-if="approvalType">
    <b-form-group>
      <template #label>Do you approve this <strong>{{approvalType}}</strong> schedule?</template>
      <b-form-radio-group stacked :options="approvalOptions" v-model="approved" @change="saveApproval()"></b-form-radio-group>
    </b-form-group>
    <b-form-group label="If no, what changes would you like to have?">
      <b-textarea v-model="approvalComment" :disabled="approved !== false" @blur="saveApprovalComments()"></b-textarea>
    </b-form-group>
  </div>
</template>

<script>
import { toastMixin } from '@/mixins'
import {
  SCHEDULE_APPROVAL_COMMENT_SAVE_ERROR,
  SCHEDULE_APPROVAL_COMMENT_SAVE_SUCCESS,
  SCHEDULE_APPROVAL_SAVE_ERROR,
  SCHEDULE_APPROVAL_SAVE_SUCCESS,
} from '@/constants/strings'

export default {
  name: 'PersonScheduleApproval',
  props: {
    approvalType: {
      type: String,
      default: null
    }
  },
  mixins: [
    toastMixin
  ],
  data: () => ({
    approvalOptions: [{text: 'Not Set', value: null}, {text: 'Yes', value: true}, {text: 'No', value: false}],
    approved: null,
    approvalComment: null,
  }),
  methods: {
    saveApproval() {
      //TODO save the value of this.approval
      this.toastPromise(Promise.resolve("Replace me"), SCHEDULE_APPROVAL_SAVE_SUCCESS(this.approvalType), SCHEDULE_APPROVAL_SAVE_ERROR(this.approvalType))
    },
    saveApprovalComments() {
      //TODO save the value of this.approvalComment 
      this.toastPromise(Promise.resolve("Replace me"), SCHEDULE_APPROVAL_COMMENT_SAVE_SUCCESS(this.approvalType), SCHEDULE_APPROVAL_COMMENT_SAVE_ERROR(this.approvalType))
    }
  }
}
</script>

<style>

</style>
