<template>
  <div v-if="approvalType">
    <model-loading-overlay :model="model" v-if="!failedToLoad">
      <b-form-group v-if="selected">
        <template #label>Czy zatwierdzasz ten <strong>{{approvalType}}</strong> harmonogram?</template>
        <b-form-radio-group stacked :options="approvalOptions" v-model="selected.approved" @change="patchSingleField('approved')"></b-form-radio-group>
      </b-form-group>
      <b-form-group label="Jeśli nie, jakie zmiany chciałbyś wprowadzić?" v-if="selected">
        <b-textarea v-model="comments" :disabled="selected.approved !== 'no'" @blur="patchSingleField('comments')"></b-textarea>
      </b-form-group>
      <span class="small text-muted">Ostatnio edytowane: {{lastEdited}}</span>
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
import { DateTime } from 'luxon';

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
    model: personScheduleApprovalModel,
  }),
  computed: {
    lastEdited() {
      if (this.selected && this.selected.updated_at !== this.selected.created_at) {
        return DateTime.fromISO(this.selected.updated_at).toFormat('DDDD, t ZZZZ');
      } else {
        return 'nigdy';
      }

    },
    comments: {
      get() {
        if (this.selected.approved === 'no') {
          return this.selected.comments;
        }
        return '';
      },
      set(val) {
        if (this.selected.approved === 'no') {
          this.selected.comments = val;
        }
      }
    }
  },
  methods: {
    patchSingleField(fieldName) {
      this.patchSelected(
        { [fieldName]: this.selected[fieldName]},
        true,
        SPECIFIC_MODEL_SAVE_SUCCESS[personScheduleApprovalModel][fieldName](this.approvalType),
        SPECIFIC_MODEL_SAVE_ERROR[personScheduleApprovalModel][fieldName](this.approvalType)
      )
    }
  },
  mounted() {
    this.fetchSelectedPersonApprovalForState(this.approvalType).then((psa) => {
      if (!psa) {
        // create a new one? or should this be henry?
        this.failedToLoad = true;
      }
    }).catch((err) => {
      this.failedToLoad = true;
    });
  }
}
</script>

<style>

</style>
```