import React from 'react'
import { View } from './View'
import { StyleSheet, TextProps, ViewProps } from 'react-native'
import { Text } from './Text'

interface CodeTagProps extends ViewProps {
  children: string
  textProps?: TextProps
}

export function CodeTag({ children, textProps, ...props }: CodeTagProps) {
  return (
    <View level={3} {...props} style={[style.container, props.style]}>
      <Text {...textProps} style={[style.text, textProps?.style]}>
        {children}
      </Text>
    </View>
  )
}

const style = StyleSheet.create({
  text: {
    // fontFamily: 'monospace',
    fontWeight: 600,
    fontSize: 16,
  },
  container: {
    padding: 8,
    paddingVertical: 6,
    borderRadius: 4,
    alignSelf: 'baseline',
  },
})
