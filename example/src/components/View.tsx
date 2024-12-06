import React from 'react'
import { View as RNView, ViewProps } from 'react-native'
import useTheme from '../hook/useTheme'

interface Props extends ViewProps {
  level?: 0 | 1 | 2 | 3
  flex?: number
}

export function View({
  children,
  style: containerStyle,
  level = 0,
  flex,
}: Props) {
  const theme = useTheme()
  const backgroundColor = !level
    ? theme.background
    : theme[`background_${level}` as keyof typeof theme]

  return (
    <RNView style={[{ backgroundColor, flex }, containerStyle]}>
      {children}
    </RNView>
  )
}
