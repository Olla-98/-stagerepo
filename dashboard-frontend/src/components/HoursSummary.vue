<script setup lang="ts">
defineProps<{
  budget: number
  recorded: number
  remaining: number
  budgetLabel?: string
}>()
</script>

<template>
  <div class="hours-grid">
    <div class="hours-stat">
      <span class="hours-stat__label">{{ budgetLabel || $t('hours.budget') }}</span>
      <strong>{{ budget }} <small>{{ $t('hours.unit') }}</small></strong>
    </div>
    <div class="hours-stat">
      <span class="hours-stat__label">{{ $t('hours.recorded') }}</span>
      <strong>{{ recorded }} <small>{{ $t('hours.unit') }}</small></strong>
    </div>
    <div class="hours-stat hours-stat--remaining">
      <span class="hours-stat__label">{{ $t('hours.remaining') }}</span>
      <strong>{{ remaining }} <small>{{ $t('hours.unit') }}</small></strong>
    </div>
  </div>
</template>
