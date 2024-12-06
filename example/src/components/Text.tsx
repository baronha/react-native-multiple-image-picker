import React from 'react'
import { Text as RNText, StyleSheet, TextProps } from 'react-native'
import useTheme from '../hook/useTheme'

export function Text({ children, style: containerStyle }: TextProps) {
  const { foreground } = useTheme()

  return (
    <RNText style={[style.text, { color: foreground }, containerStyle]}>
      {children}
    </RNText>
  )
}

const style = StyleSheet.create({
  text: {
    fontFamily: 'Avenir',
    fontWeight: 'bold',
  },
})
