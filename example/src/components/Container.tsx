import React from 'react'
import { StyleSheet, ViewProps } from 'react-native'
import useTheme from '../hook/useTheme'
import { View } from './View'

interface Props extends ViewProps {
  level?: 0 | 1 | 2 | 3
}

export function Container({
  children,
  style: containerStyle,
  level = 0,
}: Props) {
  const theme = useTheme()
  const backgroundColor = !level
    ? theme.background
    : theme[`background_${level}` as keyof typeof theme]

  return (
    <View style={[style.container, { backgroundColor }, containerStyle]}>
      {children}
    </View>
  )
}

const style = StyleSheet.create({
  container: {
    flex: 1,
  },
})
