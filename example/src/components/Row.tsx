import React from 'react'
import { StyleSheet, ViewStyle } from 'react-native'
import { View, ViewProps } from './View'

export interface RowProps extends ViewProps {
  alignItems?: ViewStyle['alignItems']
  gap?: number
}

export function Row({
  children,
  gap,
  alignItems = 'center',
  ...props
}: RowProps) {
  return (
    <View
      {...props}
      style={[style.container, props.style, { alignItems, gap }]}
    >
      {children}
    </View>
  )
}

const style = StyleSheet.create({
  container: {
    flexDirection: 'row',
  },
})
