import React from 'react'
import { View } from './View'
import { StyleSheet, ViewProps } from 'react-native'
import { Text } from './Text'

export function CodeTag({ children, ...props }: ViewProps) {
  return (
    <View level={3} {...props} style={[style.container, props.style]}>
      <Text style={style.text}>{children}</Text>
    </View>
  )
}

const style = StyleSheet.create({
  text: {
    fontFamily: 'monospace',
    fontSize: 16,
  },
  container: {
    padding: 8,
    paddingVertical: 6,
    borderRadius: 4,
  },
})
