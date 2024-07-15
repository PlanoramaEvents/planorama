<template>
  <div>
    <b-button v-b-modal.select-person-modal variant="link">Select Person</b-button>
    <plano-modal
      id="select-person-modal"
      @show="init()"
      @ok="onOk()"
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
        @change="onChange"
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
  components: {
    ComboBox,
    PlanoModal,
  },
  data: () => ({
    options: [],
    data: [],
    loading: true,
    selectedId: null,
    model,
  }),
  mixins: [modelMixinNoProp],
  watch: {
    data(newVal, oldVal) {
      if (newVal) {
        this.options = Object.values(newVal)
          .filter((obj) => !obj.json)
          .map((obj) => ({
            value: obj.id,
            text: obj.published_name,
          }));
      } else {
        this.options = [];
      }
    },
  },
  methods: {
    onChange(arg) {
      this.selectedId = arg;
    },
    load_people_combo() {
      this.loading = true;
      this.selectedId = null;
      this.search({
        "fields[person_sync_datum]": "id,published_name",
        sortBy: "published_name",
        sortOrder: "asc",
        perPage: 10000,
      }).then((data) => {
        this.data = data;
        this.loading = false;
      });
    },
    init() {
      this.load_people_combo();
    },
    onOk() {
      this.$emit("personSelected", this.selectedId);
    },
  },
};
</script>

<style lang="scss" scoped></style>
