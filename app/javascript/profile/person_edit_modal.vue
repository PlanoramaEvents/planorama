<template>
  <edit-modal
    @show="mirrorFromPerson()"
    @ok="patchPerson()"
    v-bind="$attrs"
    v-on="$listeners"
  >
    <!-- TODO pass model data to slots -->
    <slot v-for="(_, name) in $slots" :name="name" :slot="name" />
    <template v-for="(_, name) in $scopedSlots" :slot="name" slot-scope="slotData"><slot :name="name" v-bind="{...slotData, fields: data}" /></template>
  </edit-modal>
</template>

<script>
import EditModal from '@/components/edit_modal'
import { PATCH_PERSON_MODEL } from '@/store/person.store';
import { mapActions } from 'vuex';
import toastMixin from '@/shared/toast-mixin';
import { FETCH_BY_ID } from '@/store/model.store';
import { PERSON_SAVE_SUCCESS } from '@/constants/strings';

export default {
  name: "PersonEditModal",
  components: {
    EditModal
  },
  mixins: [
    toastMixin
  ],
  props: {
    person: {
      required: true,
    },
    data: {
      required: true
    }
  },
  methods: {
    ...mapActions({
      patchPersonModel: PATCH_PERSON_MODEL,
      fetchById: FETCH_BY_ID
    }),
    mirrorFromPerson() {
      Object.keys(this.data).map(k => {
        this.data[k] = this.person?.[k];
      })
    },
    patchPerson() {
      this.toastPromise(this.patchPersonModel({person: this.person, data: this.data}), PERSON_SAVE_SUCCESS).then((savedPerson) => {
        this.$emit('updated', savedPerson);
      })
    }
  }
}
</script>

<style>

</style>
