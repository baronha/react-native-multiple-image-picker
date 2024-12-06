import React from 'react'
import { StyleSheet, View } from 'react-native'
import SegmentedControl, {
  SegmentedControlProps,
} from '@react-native-segmented-control/segmented-control'

export function SegmentControl({ ...props }: SegmentedControlProps) {
  return <SegmentedControl {...props} />
}

const style = StyleSheet.create({
  segment: {
    marginHorizontal: 16,
  },
})
