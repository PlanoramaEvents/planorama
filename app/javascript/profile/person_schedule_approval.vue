<template>
  <div v-if="approvalType">
    <model-loading-overlay model="model" v-if="!failedToLoad">
      <b-form-group v-if="selected">
        <template #label>Do you approve this <strong>{{approvalType}}</strong> schedule?</template>
        <b-form-radio-group stacked :options="approvalOptions" v-model="selected.approved" @change="patchSingleField('approved')"></b-form-radio-group>
      </b-form-group>
      <b-form-group label="If no, what changes would you like to have?" v-if="selected">
        <b-textarea v-model="selected.comments" :disabled="approved !== false" @blur="patchSingleField('comments')"></b-textarea>
      </b-form-group>
    </model-loading-overlay>
    <div v-if="failedToLoad">
      <span class="text-muted font-italic">{{SCHEDULE_APPROVAL_FAIL_TO_LOAD}}</span>
    </div>
  </div>
</template>

<script>
import { personScheduleApprovalMixin, personScheduleApprovalModel, personScheduleApprovalStateOptions } from '@/store/person_schedule_approval';
import {
  SPECIFIC_MODEL_SAVE_ERROR,
  SPECIFIC_MODEL_SAVE_SUCCESS,
  SCHEDULE_APPROVAL_FAIL_TO_LOAD,
} from '@/constants/strings'
import ModelLoadingOverlay from '@/components/model_loading_overlay.vue';

export default {
  name: 'PersonScheduleApproval',
  props: {
    approvalType: {
      type: String,
      default: null
    }
  },
  components: {
    ModelLoadingOverlay
  },
  mixins: [
    personScheduleApprovalMixin
  ],
  data: () => ({
    approvalOptions: personScheduleApprovalStateOptions,
    SCHEDULE_APPROVAL_FAIL_TO_LOAD,
    failedToLoad: false,
  }),
  methods: {
    patchSingleField(fieldName) {
      this.patchSelected(
        { [fieldName]: selected[fieldName]}, 
        true, 
        SPECIFIC_MODEL_SAVE_SUCCESS[personScheduleApprovalModel][fieldName](this.approvalType),
        SPECIFIC_MODEL_SAVE_ERROR[personScheduleApprovalModel][fieldName](this.approvalType)
      )
    }
  },
  mounted() {
    this.fetchSelectedPersonApprovalForState(this.approvalType).then((psa) => {
      if (!psa) {
        console.log("no psa fetched")
        // create a new one? or should this be henry?
        this.failedToLoad = true;
      }
    }).catch((err) => {
      console.log("error fetching person approval", err)
      this.failedToLoad = true;
    });
  }
}
</script>

<style>

</style>
