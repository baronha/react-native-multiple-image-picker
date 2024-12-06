import React from 'react'
import { StyleSheet, ViewProps, ViewStyle } from 'react-native'
import { View } from './View'

interface RowProps extends ViewProps {
  alignItems?: ViewStyle['alignItems']
}

export function Row({ children, alignItems = 'center', ...props }: RowProps) {
  return (
    <View {...props} style={[style.container, props.style, { alignItems }]}>
      {children}
    </View>
  )
}

const style = StyleSheet.create({
  container: {
    flexDirection: 'row',
  },
})
