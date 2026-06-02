<template>
  <div>
    <ul v-for="rc in reportConfigs" :key="rc">
      <li>
        <a :href="reportLink(rc.id)" target="_blank">{{rc.name}}</a><br />
        <p class="ml-2">
          {{ rc.description }}
        </p>
      </li>
    </ul>

  </div>
</template>

<script>

export default {
  name: "SurveyReports",
  props: ['reportConfigs'],
  methods: {
    reportLink(id) {
      return `/submissions/filtered_submissions/${id}`;
    }
  },
}
</script>

<style>

</style>