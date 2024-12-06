import React from 'react'
import { StyleSheet } from 'react-native'
import useTheme from '../hook/useTheme'
import { View } from './View'

export default function Divider() {
  const { foreground } = useTheme()
  return <View style={[style.container, { backgroundColor: foreground }]} />
}

const style = StyleSheet.create({
  container: {
    height: 1,
    width: '100%',
    opacity: 0.2,
  },
})
