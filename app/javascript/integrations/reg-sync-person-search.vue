<template>
  <div>
    <b-button v-b-modal.select-person-modal variant="link"
      >Select Person</b-button
    >
    <plano-modal
      id="select-person-modal"
      @show="load()"
      @ok="$emit('personSelected', selectedId)"
      title="People with potential matches"
      ok-title="Go"
      headerBgVariant="primary"
      headerTextVariant="light"
      :ok-disabled="!selectedId"
    >
      <combo-box
        :options="options"
        :select-size="4"
        :loading="loading"
        v-model="selectedId"
      ></combo-box>
    </plano-modal>
  </div>
</template>

<script>
import PlanoModal from "@/components/plano_modal.vue";
import ComboBox from "../components/combo_box";
import { modelMixinNoProp } from "../store/model.mixin";
import { personSyncDatumModel as model } from "@/store/person_sync_datum.store";

export default {
  name: "RegSyncPersonSearch",
  props: {
    displayField: {
      type: String,
      default: "published_name",
    },
  },
  components: {
    ComboBox,
    PlanoModal,
  },
  data: () => ({
    options: [],
    loading: true,
    selectedId: null,
    model,
  }),
  mixins: [modelMixinNoProp],
  methods: {
    load() {
      this.loading = true;
      this.selectedId = null;
      this.search({
        [`fields[${model}]`]: `id,${this.displayField}`,
        sortBy: this.displayField,
        sortOrder: "asc",
        perPage: 10000,
      }).then((data) => {
        if (data) {
          this.options = Object.entries(data)
            .filter(([key, _]) => key !== "_jv")
            .map(([_, obj]) => ({
              value: obj.id,
              text: obj[this.displayField],
            }));
        } else {
          this.options = [];
        }
        this.loading = false;
      });
    },
  },
};
</script>

<style lang="scss" scoped></style>
