import React from 'react'
import { Text as RNText, TextProps } from 'react-native'
import useTheme from '../hook/useTheme'

export function Text({ children, style: containerStyle }: TextProps) {
  const { foreground } = useTheme()

  return (
    <RNText style={[{ color: foreground }, containerStyle]}>{children}</RNText>
  )
}
